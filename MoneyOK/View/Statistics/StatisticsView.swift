//
//  StatisticsView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 20.03.2022.
//

import SwiftUI
import Charts
import CoreData

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
    
    @State var selectedType = TypeTrancaction.expenses
    
    @State private var selectedTypeBool = true
    
    @State private var startDate = Date.today().previous(.monday)
    @State private var endDate = Date.today().next(.sunday, considerToday: true)
    
    
//    // Складывает все транзакции
//    var sumTransaction: Double {
//        fetchedTransaction.reduce(0) { $0 + $1.sumTransaction }
//    }
    
    
//    var arrayTransactions: Array<Double> {
//        fetchedTransaction.compactMap {Double($0.sumTransaction)}
//    }
    
    
    var body: some View {
        
        let data: [MountPrice] = [
            MountPrice(mount: "Expenses", value: sumTransactionTupe(type: .expenses)),
            MountPrice(mount: "Income", value: sumTransactionTupe(type: .income))
        ]
        
        NavigationView {
            VStack {
                Form {
                    Section {
                        Button {
                            //
                        } label: {
                            Label("ffff", systemImage: "clock")
                        }
                        
                    }
                    
                    Section("Total") {
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
                        
                        .padding(.all, 5)
                        .chartLegend(.hidden)
                        .frame(height: 250)
                    }
                    
                    Section("Select the type") {
                        Picker("", selection: $selectedType) {
                            ForEach(TypeTrancaction.allCases, id:\.self) { value in
                                Text(value.localizedName).tag(value)
                            }
                        }.onChange(of: selectedType) { newValue in
                            switch newValue {
                            case .expenses:
                                selectedTypeBool = false
                            case .income:
                                selectedTypeBool = true
                            }
                        }
                        
                        .pickerStyle(SegmentedPickerStyle())
                        
                    }
                    
                    Section(selectedType == .expenses ? "Expenses" : "Income") {
                        Chart(fetchedTransaction.filter({$0.transactionToCategory?.isExpenses == selectedTypeBool})) { item in
                            BarMark(
                                x: .value("Amount", abs(item.sumTransaction)),
                                y: .value("Month",  item.transactionToCategory?.nameCategory ?? "")
                            ).foregroundStyle(by: .value("Category", (item.transactionToCategory?.colorCategory!)!))
                        }
                        .padding(.all, 5)
                        .chartLegend(.hidden)
                        .frame(minHeight: 250, maxHeight: .infinity)
                    }
                    
                    
                }
            }
            
            
            .navigationTitle(Text("Statistics"))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Menu {
                        Button {
                            let date = Date()
                            let calendar = Calendar.current
                            
                            let startOfDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: date),
                                                                                 month: calendar.component(.month, from: date),
                                                                                 day: calendar.component(.day, from: date),
                                                                                 hour: 0,
                                                                                 minute: 0,
                                                                                 second: 0
                                                                                ))!
                            
                            let endOfDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: date),
                                                                               month: calendar.component(.month, from: date),
                                                                               day: calendar.component(.day, from: date),
                                                                               hour: 23,
                                                                               minute: 59,
                                                                               second: 59
                                                                              ))!
                            
                            startDate = startOfDate.previous(.monday)
                            endDate = endOfDate.next(.sunday)
                            
                            fetchedTransaction.nsPredicate = periodPredicate(startDate: startDate, endDate: endDate)

                            print("This week")
                            
                        } label: {
                            Text("This week")
                        }
                        
                        Button {
                            let date = Date()
                            let calendar = Calendar.current
                            
                            // Add 7 days
                            let dateLast = Calendar.current.date(byAdding: .day, value: -7, to: date)
                            
                            let startOfDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: dateLast!),
                                                                                 month: calendar.component(.month, from: dateLast!),
                                                                                 day: calendar.component(.day, from: dateLast!),
                                                                                 hour: 0,
                                                                                 minute: 0,
                                                                                 second: 0
                                                                                ))!
                            
                            let endOfDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: date),
                                                                               month: calendar.component(.month, from: date),
                                                                               day: calendar.component(.day, from: date),
                                                                               hour: 23,
                                                                               minute: 59,
                                                                               second: 59
                                                                              ))!
                            
                            
                            startDate = startOfDate.previous(.monday)
                            endDate = endOfDate.previous(.sunday)
                            
                            fetchedTransaction.nsPredicate = periodPredicate(startDate: startDate, endDate: endDate)
                            
                            
                            print("Last week")
                            
                            //
                        } label: {
                            Text("Last week")
                        }
                        
                    } label: {
                        Label("Options", systemImage: "calendar")
                    }
                }
            }
            .onAppear {
                fetchedTransaction.nsPredicate = periodPredicate(startDate: startDate, endDate: endDate)
            }
        }
        
        
    }
    
    
    /// Розрахунок загальних витрат або дохіда
    /// - Parameter type: Тип транзакції (виьрата, дохід)
    /// - Returns: число
    func sumTransactionTupe(type: TypeTrancaction) -> Double {
        var result = 0.0
        switch type {
        case .expenses:
            result = abs(fetchedTransaction.filter({$0.transactionToCategory?.isExpenses == false})
                .reduce(0) { $0 + $1.sumTransaction})
        case .income:
            result = fetchedTransaction.filter({$0.transactionToCategory?.isExpenses == true})
                .reduce(0) { $0 + $1.sumTransaction}
        }
        
        return result
    }
    
    private func periodPredicate(startDate: Date, endDate: Date) -> NSPredicate? {
        if startDate == Date() { return nil }
        let filterPeriod = NSPredicate(format: "dateTransaction >= %@ AND dateTransaction <= %@", startDate as NSDate, endDate as NSDate)

        return filterPeriod
    }
    
//    private func categoryPredicate(type: Bool) -> NSPredicate? {
//
//        let filterPeriod = NSPredicate(format: "(transactionToCategory.isExpenses == %d)", type)
//        return filterPeriod
//    }
    
    private func categoryAndDataPredicate(type: Bool, startDate: Date, endDate: Date) -> NSPredicate? {
        
        //
        let filterType = NSPredicate(format: "(transactionToCategory.isExpenses == %d)", type)
        
        let filterPeriod = NSPredicate(format: "dateTransaction >= %@ AND dateTransaction <= %@", startDate as NSDate, endDate as NSDate)
        
        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [filterType, filterPeriod])
        
        return andPredicate
        
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TransactionEntity")
//        fetchRequest.predicate = andPredicate
//
//        return ((try? viewContext.count(for: fetchRequest)) ?? 0)
        
    }
    
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
