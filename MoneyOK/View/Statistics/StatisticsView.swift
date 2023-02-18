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
    @State var selectedTypeFilterDate = TypeFilterDate.today
    
    @State private var selectedTypeBool = false
    
    @State private var startDate = Date.today().previous(.monday)
    @State private var endDate = Date.today().next(.sunday, considerToday: true)
    
    @State private var selectedDatePicker = Date()
    
    private var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }()
    
    
    var body: some View {
        
        let data: [MountPrice] = [
            MountPrice(mount: "Expenses", value: sumTransactionTupe(type: .expenses)),
            MountPrice(mount: "Income", value: sumTransactionTupe(type: .income))
        ]
        
        NavigationView {
            VStack {
                Form {
                    Picker(selection: $selectedTypeFilterDate, label:
                            HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.white)
                            .padding(.all, 5)
                            .background(Color.red)
                            .cornerRadius(5)
                        Text("Date")
                            .font(.headline)
                    }
                    ) {
                        ForEach(TypeFilterDate.allCases, id:\.self) { value in
                            Text(value.localizedName).tag(value)
                        }
                    }
                    /// Конкретна дата
                    if selectedTypeFilterDate == .exactDate {
                        DatePicker("Select date", selection: $selectedDatePicker, in: ...Date.now, displayedComponents: .date)
                    }
                    /// До дати
                    if selectedTypeFilterDate == .toTheDate {
                        DatePicker("Select date", selection: $selectedDatePicker, in: ...Date.now, displayedComponents: .date)
                    }
                    /// Після дати
                    if selectedTypeFilterDate == .aftertheDate {
                        DatePicker("Select date", selection: $selectedDatePicker, in: ...Date.now, displayedComponents: .date)
                    }
                    /// Диапазон
                    if selectedTypeFilterDate == .rangeDate {
                        DatePicker("From", selection: $selectedDatePicker, in: ...endDate, displayedComponents: .date)
                        DatePicker("To", selection: $endDate, in: selectedDatePicker..., displayedComponents: .date)
                    }
                    
                    Section(header: Text("Total: \(startDate, formatter: formatter) - \(endDate, formatter: formatter)").font(.footnote)) {
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
                
            }
            
            .onChange(of: selectedTypeFilterDate, perform: { value in
                if selectedTypeFilterDate == .today {
                    
                    let date = Date()
                    let calendar = Calendar.current
                    
                    let startOfDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: date), month: calendar.component(.month, from: date), day: calendar.component(.day, from: date),
                                                                         hour: 0,
                                                                         minute: 0,
                                                                         second: 0
                                                                        ))!
                    
                    let endOfDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: date), month: calendar.component(.month, from: date), day: calendar.component(.day, from: date),
                                                                       hour: 23,
                                                                       minute: 59,
                                                                       second: 59
                                                                      ))!
                    
                    startDate = startOfDate
                    endDate = endOfDate
                    fetchedTransaction.nsPredicate = periodPredicate(startDate: startOfDate, endDate: endOfDate)
                }
            })
            
            .onChange(of: selectedDatePicker, perform: { value in
                if selectedTypeFilterDate == .exactDate {
                    
                    let calendar = Calendar.current
                    
                    let startOfDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: selectedDatePicker), month: calendar.component(.month, from: selectedDatePicker), day: calendar.component(.day, from: selectedDatePicker),
                                                                         hour: 0,
                                                                         minute: 0,
                                                                         second: 0
                                                                        ))!
                    
                    let endOfDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: selectedDatePicker), month: calendar.component(.month, from: selectedDatePicker), day: calendar.component(.day, from: selectedDatePicker),
                                                                       hour: 23,
                                                                       minute: 59,
                                                                       second: 59
                                                                      ))!
                    
                    startDate = startOfDate
                    endDate = endOfDate
                    fetchedTransaction.nsPredicate = periodPredicate(startDate: startOfDate, endDate: endOfDate)
                }
                
                if selectedTypeFilterDate == .toTheDate {
                    
                    let defaultDate = Calendar.current.date(byAdding: DateComponents(year: -5), to: Date()) ?? Date()
                    let calendar = Calendar.current
                    
                    let startOfDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: defaultDate), month: calendar.component(.month, from: defaultDate), day: calendar.component(.day, from: defaultDate),
                                                                         hour: 0,
                                                                         minute: 0,
                                                                         second: 0
                                                                        ))!
                    
                    let endOfDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: selectedDatePicker), month: calendar.component(.month, from: selectedDatePicker), day: calendar.component(.day, from: selectedDatePicker),
                                                                       hour: 23,
                                                                       minute: 59,
                                                                       second: 59
                                                                      ))!
                    
                    startDate = startOfDate
                    endDate = endOfDate
                    fetchedTransaction.nsPredicate = periodPredicate(startDate: startOfDate, endDate: endOfDate)
                    
                }
                
                if selectedTypeFilterDate == .aftertheDate {
                    
                    let dateNow = Date()
                    let calendar = Calendar.current
                    
                    let startOfDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: selectedDatePicker), month: calendar.component(.month, from: selectedDatePicker), day: calendar.component(.day, from: selectedDatePicker),
                                                                         hour: 0,
                                                                         minute: 0,
                                                                         second: 0
                                                                        ))!
                    
                    let endOfDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: dateNow), month: calendar.component(.month, from: dateNow), day: calendar.component(.day, from: dateNow),
                                                                       hour: 23,
                                                                       minute: 59,
                                                                       second: 59
                                                                      ))!
                    
                    startDate = startOfDate
                    endDate = endOfDate
                    fetchedTransaction.nsPredicate = periodPredicate(startDate: startOfDate, endDate: endOfDate)
                    
                }
                
                if selectedTypeFilterDate == .rangeDate {
                    
                    let calendar = Calendar.current
                    
                    let startOfDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: selectedDatePicker), month: calendar.component(.month, from: selectedDatePicker), day: calendar.component(.day, from: selectedDatePicker),
                                                                         hour: 0,
                                                                         minute: 0,
                                                                         second: 0
                                                                        ))!
                    
                    let endOfDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: endDate), month: calendar.component(.month, from: endDate), day: calendar.component(.day, from: endDate),
                                                                       hour: 23,
                                                                       minute: 59,
                                                                       second: 59
                                                                      ))!
                    
                    startDate = startOfDate
                    
                    fetchedTransaction.nsPredicate = periodPredicate(startDate: startOfDate, endDate: endOfDate)
                    
                }
            })
            
            .onChange(of: endDate, perform: { value in
                
                if selectedTypeFilterDate == .rangeDate {
                    
                    let calendar = Calendar.current
                    
                    let startOfDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: selectedDatePicker), month: calendar.component(.month, from: selectedDatePicker), day: calendar.component(.day, from: selectedDatePicker),
                                                                         hour: 0,
                                                                         minute: 0,
                                                                         second: 0
                                                                        ))!
                    
                    let endOfDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: endDate), month: calendar.component(.month, from: endDate), day: calendar.component(.day, from: endDate),
                                                                       hour: 23,
                                                                       minute: 59,
                                                                       second: 59
                                                                      ))!
                    
                    startDate = startOfDate
                    
                    fetchedTransaction.nsPredicate = periodPredicate(startDate: startOfDate, endDate: endOfDate)
                    
                }
            })
            
            .onAppear {
                let date = Date()
                let calendar = Calendar.current
                
                let startOfDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: date), month: calendar.component(.month, from: date), day: calendar.component(.day, from: date),
                                                                     hour: 0,
                                                                     minute: 0,
                                                                     second: 0
                                                                    ))!
                
                let endOfDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: date), month: calendar.component(.month, from: date), day: calendar.component(.day, from: date),
                                                                   hour: 23,
                                                                   minute: 59,
                                                                   second: 59
                                                                  ))!
                
                startDate = startOfDate.previous(.monday)
                endDate = endOfDate.next(.sunday)
                
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
    
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
