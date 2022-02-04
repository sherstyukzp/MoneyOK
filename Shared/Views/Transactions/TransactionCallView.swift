//
//  TransactionCallView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 04.02.2022.
//

import SwiftUI

struct TransactionCallView: View {
    
    @ObservedObject var transaction: Transaction
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Sum : \(transaction.sumTransaction)").font(.title2)
        }
    }
}

struct TransactionCallView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionCallView(transaction: Transaction())
    }
}
