//
//  TransactionsView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 09.02.2022.
//

import SwiftUI

struct TransactionsView: View {

    @ObservedObject var accountItem: AccountEntity
    
    @State private var isNewTransaction = false

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
        
        
    }
}

struct TransactionsView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsView(accountItem: AccountEntity())
    }
}
