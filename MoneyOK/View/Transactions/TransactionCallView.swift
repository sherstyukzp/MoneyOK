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
    
    // Alert
    @State var showAlert: Bool = false
    @State var alertTitle: String = "Deleting a transaction"
    @State var alertMessage: String = "Are you sure you want to delete the transaction?"
    
    @State var showDetails: Bool = false
    
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
            Text("\(transactionItem.sumTransaction, format: .currency(code: "USD"))")
                .bold()
                .foregroundColor(Color (transactionItem.sumTransaction < 0 ? .red : .green))
            
            Button {
                showDetails.toggle()
            } label: {
                Image(systemName: "info.circle")
            }

        }
//        
//        .navigationDestination(isPresented: $showDetails) {
//        TransactionDetailView(transactionItem: transactionItem)
//        }
            
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
                showAlert.toggle()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        
        .alert(isPresented: $showAlert) {
            getAlert()
        }
    }
    
    // MARK: Alert
    func getAlert() -> Alert {
        return Alert(title: Text(alertTitle),
                     message: Text(alertMessage),
                     primaryButton: .destructive(Text("Yes"),
                                                 action: {
            transactionVM.delete(transaction: transactionItem, context: viewContext)
        }),
                     secondaryButton: .cancel())
    }
}

struct TransactionCallView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionCallView(transactionItem: TransactionEntity())
    }
}
