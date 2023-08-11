//
//  TransactionDetailView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 11.02.2022.
//

import SwiftUI

struct TransactionDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var transactionVM: TransactionViewModel
    
    @ObservedObject var transactionItem: TransactionEntity
    
    // Alert
    @State var showAlert: Bool = false
    @State var alertTitle: String = "Removing a transaction"
    @State var alertMessage: String = "Do you really want to delete a transaction?"
    
    @State private var zoomed = false
    @Namespace private var smooth
    
    var body: some View {
        HStack {
            Text("\(transactionItem.sumTransaction > 0 ? "+" : "")")
                
            Text("\(transactionItem.sumTransaction, format: .currency(code: "USD"))")
                
        }.foregroundColor(Color(transactionItem.sumTransaction > 0 ? .green : .red))
            .font(.system(size: 48, weight: .bold, design: .default))
        
        Form {
            Section {
                Text ("Account: \(transactionItem.transactionToAccount?.nameAccount ?? "")")
                Text ("Category: \(transactionItem.transactionToCategory?.nameCategory ?? "")")
                Text ("Date: \(transactionItem.dateTransaction ?? Date() , style: .date)")

            }
            Section(header: Text("Note")) {
                Text(transactionItem.noteTransaction ?? "Not note")
               
            }
            Section(header: Text("Image")) {
                if transactionItem.imageTransaction != nil {
                    Image(uiImage: UIImage(data: transactionItem.imageTransaction!)!)
                        .resizable()
                        .frame(width: 60, height: 60)
                    
                } else {
                    Text("Not image")
                }
            }.onTapGesture {
                zoomed.toggle()
            }
            
            Section {
                Button(role: .destructive) {
                    showAlert.toggle()
                } label: {
                    Text("Delete")
                }
            }
        }
        
        .alert(isPresented: $showAlert) {
            getAlert()
        }
        
        .navigationBarTitle((transactionItem.transactionToCategory?.nameCategory) ?? "", displayMode: .inline)
    }
        
    // MARK: Alert
    func getAlert() -> Alert {
        return Alert(title: Text(alertTitle),
                     message: Text(alertMessage),
                     primaryButton: .destructive(Text("Yes"),
                                                 action: {
            transactionVM.delete(transaction: transactionItem)
            dismiss()
        }),
                     secondaryButton: .cancel())
    }
}

struct TransactionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionDetailView(transactionItem: TransactionEntity())
    }
}
