//
//  TransactionCallView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 04.02.2022.
//

import SwiftUI

struct TransactionCallView: View {
    
    @ObservedObject var transaction: Transaction
    @ObservedObject var account: AccountEntity
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Категория: " + account.nameAccount!).font(.title2) 
            Text("Sum : \(transaction.sumTransaction)").font(.title2)
                .foregroundColor(Color(transaction.sumTransaction < 0 ? .red : .blue))
        }
    }
}

struct TransactionCallView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionCallView(transaction: Transaction(), account: AccountEntity())
    }
}
