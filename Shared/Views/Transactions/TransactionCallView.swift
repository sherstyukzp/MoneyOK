//
//  TransactionCallView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 04.02.2022.
//

import SwiftUI

struct TransactionCallView: View {
    
    @ObservedObject var transaction: TransactionEntity
    @ObservedObject var account: AccountEntity
    //@ObservedObject var category: CategoryEntity
    
    var body: some View {
        VStack(alignment: .leading) {
            //Text("Категория: \(category.nameCategory ?? "")").font(.title2)
            Text("Sum : \(transaction.sumTransaction)").font(.title2)
                .foregroundColor(Color(transaction.sumTransaction < 0 ? .red : .blue))
        }
    }
}

struct TransactionCallView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionCallView(transaction: TransactionEntity(), account: AccountEntity())
    }
}
