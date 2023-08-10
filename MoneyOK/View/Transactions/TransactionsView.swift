//
//  TransactionsView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 09.02.2022.
//

import SwiftUI


struct TransactionsView: View {
    
    @EnvironmentObject var accountVM: AccountViewModel
    @ObservedObject var accountItem: AccountEntity
    @State private var isStatistics = false
    @State private var isNewTransaction = false
    
    @State private var isExportCSV = false
    
    // Сумма всех транзакций выбраного счёта
    var sumTransactionForAccount: Double {
        accountItem.transaction.reduce(0) { $0 + $1.sumTransaction }
    }
    
    var body: some View {
        NavigationStack {
            TransactionsListView(accountItem: accountItem)
                .navigationTitle(accountItem.nameAccount ?? "")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    // Меню по работе с счётом
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if !accountItem.transaction.isEmpty {
                            Menu {
                                // Статистика
                                Button {
                                    self.isStatistics.toggle()
                                } label: {
                                    Label("Statistics", systemImage: "chart.xyaxis.line")
                                }
                                // Экспорт транзакций
                                Button {
                                    exportCSV()
                                } label: {
                                    Label("Export CSV", systemImage: "square.and.arrow.up")
                                }
                            }
                        label: {
                            Label("Menu", systemImage: "ellipsis.circle")
                        }
                        }
                    }
                    // Отображение название счёта и остаток по счёту
                    ToolbarItem(placement: .principal) {
                        VStack {
                            Text(accountItem.nameAccount ?? "")
                                .font(.headline)
                                .foregroundColor(Color(accountItem.colorAccount ?? ""))
                            Text("\(sumTransactionForAccount, format: .currency(code: "\(accountItem.currency ?? "")"))")
                                .font(.footnote)
                        }
                    }
                    // Кнопка добавления новой транзакции в текущем счёте
                    ToolbarItemGroup(placement: .bottomBar) {
                        HStack {
                            Button {
                                accountVM.accountSelect = accountItem // костиль для планшета
                                isNewTransaction.toggle()
                            } label: {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Transaction")
                                }.fontWeight(.bold)
                            }
                            Spacer()
                        }
                    }
                }
        }
        
        .sheet(isPresented: $isNewTransaction) {
            TransactionNewView(accountItem: accountItem)
        }
        .sheet(isPresented: $isStatistics) {
            StatisticsTransactionsView(accountItem: accountItem)
        }
        
    }
    
    func exportCSV() {
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
        
        isExportCSV.toggle()
    }
}

struct TransactionsView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsView(accountItem: AccountEntity())
    }
}
