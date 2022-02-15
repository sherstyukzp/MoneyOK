//
//  TransactionCallView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 09.02.2022.
//

import SwiftUI

struct TransactionCallView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var transactionVM: TransactionViewModel
    @ObservedObject var transactionItem: TransactionEntity
    
    var body: some View {
        
        HStack {
            ZStack {
                Circle()
                    .fill(Color(transactionItem.transactionToCategory?.colorCategory ?? "swatch_articblue"))
                    .frame(width: 32, height: 32)
                Image(systemName: transactionItem.transactionToCategory?.iconCategory ?? "creditcard.fill")
                    .foregroundColor(Color.white)
                    .font(Font.footnote)
            }
            
            VStack(alignment: .leading) {
                Text(transactionItem.transactionToCategory?.nameCategory ?? "")
                    .bold()
                    .foregroundColor(.primary)
                if transactionItem.noteTransaction != "" {
                    Text(transactionItem.noteTransaction ?? "")
                        .font(Font.footnote)
                        .foregroundColor(Color.gray)
                }
                
                
            }
            Spacer()
            Text("\(transactionItem.sumTransaction, format: .currency(code: "UAH"))")
                .bold()
                .foregroundColor(Color (transactionItem.sumTransaction < 0 ? .red : .green))
            
        }
        
        
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
                transactionVM.delete(transaction: transactionItem, context: viewContext)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

struct TransactionCallView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionCallView(transactionItem: TransactionEntity())
    }
}
