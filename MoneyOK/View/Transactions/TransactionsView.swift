//
//  TransactionsView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 09.02.2022.
//

import SwiftUI


struct TransactionsView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var accountItem: AccountEntity
    @EnvironmentObject var accountVM: AccountViewModel
    
    @State private var isNewTransaction = false
    @State private var isEditAccount = false // Вызов редактирования счёта
    
    // Alert
    @State var showAlert: Bool = false
    @State var alertTitle: String = "Removal account"
    @State var alertMessage: String = "Are you sure you want to delete the account?"
    
    @State private var isShareSheetShowing = false
    @State private var isStatistics = false
    
    // Сумма всех транзакций выбраного счёта
    var sumTransactionForAccount: Double {
        accountItem.transaction.reduce(0) { $0 + $1.sumTransaction }
    }
    
    var body: some View {
        NavigationView {
                if accountItem.transaction.isEmpty {
                    NotTransactionsView()
                } else {
                    TransactionsListView(accountItem: accountItem)
                }
            
            }
        
        .toolbar {
            // Меню по работе с счётом
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    if !accountItem.transaction.isEmpty {
                        // Статистика
                        Button {
                            self.isStatistics.toggle()
                        } label: {
                            Label("Statistics", systemImage: "chart.xyaxis.line")
                        }
                        // Экспорт транзакций
                        Button{
                            shareButton()
                        } label: {
                            Label("Export CSV", systemImage: "square.and.arrow.up")
                        }
                    }
                    
                    // Редактирование счёта из меню
                    Button(action: {
                        accountVM.accountModel.nameAccount = accountItem.nameAccount!
                        accountVM.accountModel.iconAccount = accountItem.iconAccount!
                        accountVM.accountModel.colorAccount = accountItem.colorAccount!
                        accountVM.accountModel.noteAccount = accountItem.noteAccount!
                        accountVM.accountItem = accountItem
                        self.isEditAccount.toggle()
                    }) {
                        Label("Edit Account", systemImage: "pencil")
                    }
                    Divider()
                    // Удаление счёта из меню
                    Button(role: .destructive) {
                        showAlert.toggle()
                    } label: {
                        Label("Delete Account", systemImage: "trash")
                    }
                    
                    // TODO: Добавить сортировку транзакций
                    
                    // TODO: Добавить поделиться счётом
                }
            label: {
                Label("Menu", systemImage: "ellipsis.circle")
            }
            }
            // Отображение название счёта и остаток по счёту
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(accountItem.nameAccount ?? "")
                        .font(.headline)
                        .foregroundColor(Color(accountItem.colorAccount ?? ""))
                    Text("\(sumTransactionForAccount, format: .currency(code: "USD"))").font(.subheadline)
                }
            }
            // Кнопка добавления новой транзакции в текущем счёте
            ToolbarItemGroup(placement: .bottomBar) {
                HStack {
                        Button {
                            self.isNewTransaction.toggle()
                        } label: {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Transaction")
                            }.fontWeight(.bold)
                        }
                    }
            }
        }
    
        .sheet(isPresented: $isNewTransaction) {
            TransactionNewView()
        }
        
        .sheet(isPresented: $isEditAccount) {
            AccountNewView()
        }
        .sheet(isPresented: $isStatistics) {
            StatisticsTransactionsView(accountItem: accountItem, isStatistics: $isStatistics)
        }
        
        .alert(isPresented: $showAlert) {
            getAlert()
        }
        
        
    }
    
    // MARK: Alert
    func getAlert() -> Alert {
        return Alert(title: Text(alertTitle),
                     message: Text(alertMessage),
                     primaryButton: .destructive(Text("Yes"),
                                                 action: {
            accountVM.delete(account: accountItem, context: viewContext)
        }),
                     secondaryButton: .cancel())
    }
    
    func shareButton() {
        let fileName = accountItem.nameAccount! + ".csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        var csvText = "Date,Category,Sun,Note\n"

        for transaction in accountItem.transaction {
            csvText += "\(transaction.dateTransaction ?? Date()),\(transaction.transactionToCategory?.nameCategory ?? ""),\(transaction.sumTransaction),\(transaction.noteTransaction ?? "not note")\n"
        }

        do {
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
        print(path ?? "not found")

        var filesToShare = [Any]()
        filesToShare.append(path!)

        let av = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
        
              if let vc = UIApplication.shared.windows.first?.rootViewController{
                  av.popoverPresentationController?.sourceView = vc.view
                 //Setup share activity position on screen on bottom center
                  av.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height, width: 0, height: 0)
                  av.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
                 vc.present(av, animated: true, completion: nil)
              }

        isShareSheetShowing.toggle()
    }
    
    
}

struct TransactionsView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsView(accountItem: AccountEntity())
    }
}
