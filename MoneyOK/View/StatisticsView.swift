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
    
    @State var selectedType = TypeTrancaction.costs
    
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
                GroupBox ("Expenses/Income") {
                    Chart(data) { item in
                        BarMark(
                            x: .value("Mount", item.mount),
                            y: .value("Value", item.value)
                        ).foregroundStyle(by: .value("Type", item.mount))
                            .annotation(alignment: .center, spacing: 10) {
                                Text("\(item.value, format: .currency(code: "USD"))")
                                    .fontWeight(.bold)
                            }
                    }
                    .chartLegend(.hidden)
                    .frame(height: 250)
                }
                
                Picker("", selection: $selectedType) {
                    ForEach(TypeTrancaction.allCases, id:\.self) { value in
                        Text(value.localizedName).tag(value)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                if selectedType == .costs {
                    
                    GroupBox ("By category of Expenses") {
                        Chart(fetchedTransaction.filter({$0.transactionToCategory?.isExpenses == false})) { item in
                            BarMark(
                                x: .value("Amount", abs(item.sumTransaction)),
                                y: .value("Month",  item.transactionToCategory?.nameCategory ?? "")
                            ).foregroundStyle(by: .value("Category", (item.transactionToCategory?.colorCategory!)!))
                        }
                        .chartLegend(.hidden)
                        .frame(minHeight: 250, maxHeight: .infinity)
                    }
                }
                
                if selectedType == .income {
                    GroupBox ("By category of Income") {
                        Chart(fetchedTransaction.filter({$0.transactionToCategory?.isExpenses == true})) { item in
                            BarMark(
                                x: .value("Amount", abs(item.sumTransaction)),
                                y: .value("Month",  item.transactionToCategory?.nameCategory ?? "")
                            ).foregroundStyle(by: .value("Category", (item.transactionToCategory?.colorCategory!)!))
                        }
                        .chartLegend(.hidden)
                        .frame(minHeight: 250, maxHeight: .infinity)
                    }
                }
                
                
            }.padding(.all)
            
            
                .navigationTitle(Text("Statistics"))
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            dismiss()
                        } label: {
                            Text("Cancel")
                        }
                        
                    }
                }
        }
        
    }
    
    /// Розрахунок загальних витрат або дохіда
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
