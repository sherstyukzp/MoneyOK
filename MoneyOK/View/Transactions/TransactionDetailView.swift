//
//  TransactionDetailView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 11.02.2022.
//

import SwiftUI

struct TransactionDetailView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var transactionVM: TransactionViewModel
    
    @ObservedObject var transactionItem: TransactionEntity
    
    // Alert
    @State var showAlert: Bool = false
    @State var alertTitle: String = "Удаление транзакции"
    @State var alertMessage: String = "Вы действительно хотите удалить транзакцию?"
    
    var body: some View {
        HStack {
            Text("\(transactionItem.sumTransaction > 0 ? "+" : "")")
                
            Text("\(transactionItem.sumTransaction, format: .currency(code: "UAH"))")
                
        }.foregroundColor(Color(transactionItem.sumTransaction > 0 ? .green : .red))
            .font(.system(size: 48, weight: .bold, design: .default))
        
        Form {
            Section {
                Text ("Счёт: \(transactionItem.transactionToAccount?.nameAccount ?? "")")
                Text ("Категория: \(transactionItem.transactionToCategory?.nameCategory ?? "")")
                Text ("Дата: \(transactionItem.dateTransaction ?? Date())")
            }
            Section {
                Text ("Заметки: \(transactionItem.noteTransaction ?? "")")
                Text ("Фото:") // TODO: Добавить отображение фото транзакции
            }
            
            Section {
                Button(role: .destructive) {
                    showAlert.toggle()
                    
                    
                } label: {
                    Text("Удалить")
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
                     primaryButton: .destructive(Text("Да"),
                                                 action: {
            transactionVM.delete(transaction: transactionItem, context: viewContext)
            presentationMode.wrappedValue.dismiss() // Закрытие окна, вернуться в список транзакций
        }),
                     secondaryButton: .cancel())
    }
}

struct TransactionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionDetailView(transactionItem: TransactionEntity())
    }
}
