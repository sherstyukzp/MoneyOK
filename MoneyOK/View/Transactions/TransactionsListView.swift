//
//  TransactionsListView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 09.02.2022.
//

import SwiftUI

struct TransactionsListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var accountItem: AccountEntity
    
    
    var body: some View {
        List {
            ForEach(self.accountItem.transaction, id: \.self) { item in
                
                NavigationLink(destination:
                                TransactionDetailView(transactionItem: item))
                {
                    TransactionCallView(transactionItem: item)
                }//.isDetailLink(true) // Исправляет баг с tabbar в списке транзакций
                .swipeActions() {
                }
                
            }
        }
    }
}

struct TransactionsListView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsListView(accountItem: AccountEntity())
    }
}
