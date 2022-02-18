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
    
    // Alert
    @State var showAlert: Bool = false
    @State var alertTitle: String = "Удаление счёта"
    @State var alertMessage: String = "Вы действительно хотите удалить счёт?"
    
    
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
                Text("Нет транзакций!")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                Text("Для добавление новой транзакции нажмите на кнопку ''Новая транзакция''.")
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30.0)
            } else {
                TransactionsListView(accountItem: accountItem)
            }
            
        }
        
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                                Menu {
                                    Button(action: {
                                        
                                    }) {
                                        Label("Create a file", systemImage: "doc")
                                    }
                                    Divider()

                                    Button(role: .destructive) {
                                        showAlert.toggle()
                                    } label: {
                                        Label("Удалить", systemImage: "trash")
                                    }
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
                    Text("\(sumTransactionForAccount, format: .currency(code: "UAH"))").font(.subheadline)
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
                    Text("Новая транзакция").bold()
                        .foregroundColor(Color.blue)
                }
                
                Spacer()
            }
        }
        
        .sheet(isPresented: $isNewTransaction) {
            TransactionNewView(accountItem: accountItem, isNewTransaction: $isNewTransaction, nowAccount: true)
        }
        
        .alert(isPresented: $showAlert) {
            getAlert()
        }
        
        
    }
    
    // MARK: Alert
    func getAlert() -> Alert {
        return Alert(title: Text(alertTitle),
                     message: Text(alertMessage),
                     primaryButton: .destructive(Text("Да"),
                                                 action: {
            accountVM.delete(account: accountItem, context: viewContext)
        }),
                     secondaryButton: .cancel())
    }
}

struct TransactionsView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsView(accountItem: AccountEntity())
    }
}
