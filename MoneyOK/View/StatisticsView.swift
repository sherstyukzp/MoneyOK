//
//  StatisticsView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 20.03.2022.
//

import SwiftUI
import Charts

struct MountPrice: Identifiable {
    var id = UUID()
    var mount: String
    var value: Double
}

struct StatisticsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: TransactionEntity.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \TransactionEntity.dateTransaction, ascending: true)])
    private var fetchedTransaction: FetchedResults<TransactionEntity>

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \CategoryEntity.nameCategory, ascending: true)])
    private var fetchedCategory:FetchedResults<CategoryEntity>
    
    
    // Складывает все транзакции
    var sumTransaction: Double {
        fetchedTransaction.reduce(0) { $0 + $1.sumTransaction }
    }
    
    
    var arrayTransactions: Array<Double> {
        fetchedTransaction.compactMap {Double($0.sumTransaction)}
    }
    
    
    var body: some View {
        
        let data: [MountPrice] = [
            MountPrice(mount: "Expenses", value: sumTransactionTupe(type: .costs)),
            MountPrice(mount: "Income", value: sumTransactionTupe(type: .income))
            ]
        
        NavigationView {
            ScrollView(showsIndicators: false) {
                    GroupBox ("Type") {
                        Chart(data) {
                            BarMark(
                                x: .value("Mount", $0.mount),
                                y: .value("Value", $0.value)
                            ).foregroundStyle(by: .value("Type", $0.mount))
                            
                        }
                        .chartLegend(.hidden)
                        .frame(height: 250)
                    }
                GroupBox ("By category of Expenses") {
                    Chart(fetchedCategory.filter{$0.isExpenses == false}) { item in
                        BarMark(
                            x: .value("Amount", item.categoryToTransaction?.count ?? 0),
                            y: .value("Month", item.nameCategory ?? "")
                        ).foregroundStyle(by: .value("Category", item.colorCategory!))
                            .annotation(position: .overlay, alignment: .leading, spacing: 3) {
                                Image(systemName: item.iconCategory!)
                                    .foregroundColor(.white)
                            }
                            
                        
                    }
                    .chartLegend(.hidden)
                    .frame(height: 250)
                }
                
                GroupBox ("By category of Income") {
                    Chart(fetchedCategory.filter{$0.isExpenses == true}) { item in
                        BarMark(
                            x: .value("Amount", item.categoryToTransaction?.count ?? 0),
                            y: .value("Month", item.nameCategory ?? "")
                        ).foregroundStyle(by: .value("Category", item.colorCategory!))
                            .annotation(position: .overlay, alignment: .leading, spacing: 3) {
                                Image(systemName: item.iconCategory!)
                                    .foregroundColor(.white)
                            }
                    }
                    .chartLegend(.hidden)
                    .frame(height: 250)
                }
                
                    
            }.padding(.all)
            
            
            .navigationTitle(Text("Statistics"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                    
                }
            }
        }
        
    }
    
    /// Розрахунок загальних вітрат або дохіда
    /// - Parameter type: Тип транзакції (виьрата, дохід)
    /// - Returns: число
    func sumTransactionTupe(type: TypeTrancaction) -> Double {
        
        var result = 0.0
        switch type {
        case .costs:
            result = abs(fetchedTransaction.filter({$0.transactionToCategory?.isExpenses == false})
                .reduce(0) { $0 + $1.sumTransaction})
        case .income:
            result = fetchedTransaction.filter({$0.transactionToCategory?.isExpenses == true})
                .reduce(0) { $0 + $1.sumTransaction}
        }
        
        return result
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
