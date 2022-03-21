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
        
        VStack {
            if accountItem.transaction.isEmpty {
                Image(systemName: "tray.2.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.gray)
                Text("No transactions!")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                Text("To add a new transaction, click on the ''New Transaction'' button.")
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30.0)
            } else {
                TransactionsListView(accountItem: accountItem)
            }
            
        }
        
        .toolbar {
            // Меню по работе с счётом
            ToolbarItem(placement: .primaryAction) {
                                Menu {
                                    // Статистика
                                    Button{
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
                                    // Редактирование счёта из меню
                                    Button(action: {
                                        accountVM.nameAccountSave = accountItem.nameAccount!
                                        accountVM.iconAccountSave = accountItem.iconAccount!
                                        accountVM.colorAccountSave = accountItem.colorAccount!
                                        accountVM.noteAccountSave = accountItem.noteAccount!
                                        accountVM.accountItem = accountItem
                                        self.isEditAccount.toggle()
                                    }) {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                    Divider()
                                    // Удаление счёта из меню
                                    Button(role: .destructive) {
                                        showAlert.toggle()
                                    } label: {
                                        Label("Delete", systemImage: "trash")
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
                Button(action: {
                    self.isNewTransaction.toggle()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .imageScale(.medium)
                        .font(.title)
                        .foregroundColor(Color.blue)
                    Text("New transaction").bold()
                        .foregroundColor(Color.blue)
                }
                
                Spacer()
            }
        }
        
        .sheet(isPresented: $isNewTransaction) {
            TransactionNewView(accountItem: accountItem, isNewTransaction: $isNewTransaction, nowAccount: true)
        }
        
        .sheet(isPresented: $isEditAccount) {
            AccountNewView(isNewAccount: $isEditAccount)
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

        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)

        isShareSheetShowing.toggle()
    }
}

struct TransactionsView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsView(accountItem: AccountEntity())
    }
}
