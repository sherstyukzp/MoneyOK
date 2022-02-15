//
//  TransactionAllListView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 13.02.2022.
//

import SwiftUI

struct TransactionAllListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: TransactionEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \TransactionEntity.idTransaction, ascending: true)])
    private var fetchedTransaction: FetchedResults<TransactionEntity>
    
    // Складывает все транзакции
    var sumTransaction: Double {
        fetchedTransaction.reduce(0) { $0 + $1.sumTransaction }
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(fetchedTransaction) { transaction in
                    TransactionCallView(transactionItem: transaction)
                }
            }
            Text("Всего \(fetchedTransaction.count) транзакций")
            Text("На сумму \(sumTransaction, format: .currency(code: Locale.current.currencyCode ?? "USD"))")
        }
        
        .navigationTitle("Все транзакции")
    }
}

struct TransactionAllListView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionAllListView()
    }
}
