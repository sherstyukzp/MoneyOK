//
//  StatisticsTransactionsView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 21.03.2022.
//

import SwiftUI
import Charts

struct StatisticsTransactionsView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var accountItem: AccountEntity
    
    
    // Сумма всех транзакций выбраного счёта
    var sumTransactionForAccount: Double {
        accountItem.transaction.reduce(0) { $0 + $1.sumTransaction }
    }
    // Массив всех транзакций
    var arrayTransactions: Array<Double> {
        accountItem.accountToTransaction!
            .sorted(by: { $0.dateTransaction! < $1.dateTransaction! })
            .compactMap { Double( $0.sumTransaction)}
    }
    
    
    var body: some View {
        NavigationView {
            
            Text("")
            
                .navigationTitle(Text("Statistics"))
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Cancel").bold()
                                .foregroundColor(Color.blue)
                        }
                    }
                }
        }
    }
}

struct StatisticsTransactionsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsTransactionsView(accountItem: AccountEntity())
    }
}
