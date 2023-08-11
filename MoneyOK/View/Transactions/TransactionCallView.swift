//
//  TransactionCallView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 09.02.2022.
//

import SwiftUI

struct TransactionCallView: View {
    
    @EnvironmentObject var transactionVM: TransactionViewModel
    @ObservedObject var transactionItem: TransactionEntity
    
    // Alert
    @State var showAlert: Bool = false
    
    @State var alertMessage: String = "Are you sure you want to delete the transaction?"
    
    
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
            Text("\(transactionItem.sumTransaction, format: .currency(code: "\(transactionItem.transactionToAccount?.currency ?? "")"))")
                .bold()
                .foregroundColor(Color (transactionItem.sumTransaction < 0 ? .red : .green))
        }
            
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button {
                transactionVM.transactionItem = transactionItem
                showAlert.toggle()
            } label: {
                Label("Delete", systemImage: "trash")
            }.tint(.red)

        }
        
        .alert("Deleting a transaction", isPresented: $showAlert) {
            Button("No", role: .cancel, action: {})
            Button("Yes", role: .destructive, action: {
                transactionVM.delete(transaction: transactionItem)
            })
        } message: {
            Text("Are you sure you want to delete the transaction?")
        }

    }

}

struct TransactionCallView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionCallView(transactionItem: TransactionEntity())
    }
}
