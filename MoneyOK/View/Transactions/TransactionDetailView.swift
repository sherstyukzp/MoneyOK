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
                Text ("Дата: \(transactionItem.dateTransaction!.formatted(.dateTime.month().day().hour().minute().second()))")
            }
            Section {
                Text ("Заметки: \(transactionItem.noteTransaction ?? "")")
                Text ("Фото:") // TODO: Добавить отображение фото транзакции
            }
            
            Section {
                Button(role: .destructive) {
                    transactionVM.delete(transaction: transactionItem, context: viewContext)
                    presentationMode.wrappedValue.dismiss() // Закрытие окна, вернуться в список транзакций
                } label: {
                    Text("Удалить")
                }
            }
        }
        
        .navigationBarTitle((transactionItem.transactionToCategory?.nameCategory)!, displayMode: .inline)
    }
}

struct TransactionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionDetailView(transactionItem: TransactionEntity())
    }
}
