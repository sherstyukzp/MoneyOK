//
//  TransactionsListView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 09.02.2022.
//

import SwiftUI

struct TransactionsListView: View {
    
    @ObservedObject var accountItem: AccountEntity
    
    var body: some View {
        
        if accountItem.transaction.isEmpty {
            NotTransactionsView()
        } else {
            List {
                ForEach(self.accountItem.transaction.sorted(by: { $0.dateTransaction! > $1.dateTransaction! }) , id: \.self) { item in
                    TransactionCallView(transactionItem: item)
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
