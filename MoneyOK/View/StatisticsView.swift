//
//  StatisticsView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 20.03.2022.
//

import SwiftUI


struct StatisticsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: TransactionEntity.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \TransactionEntity.dateTransaction, ascending: true)])
    private var fetchedTransaction: FetchedResults<TransactionEntity>

    @FetchRequest(entity: CategoryEntity.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \CategoryEntity.nameCategory, ascending: true)])
    private var fetchedCategory: FetchedResults<CategoryEntity>
    
    
    // Складывает все транзакции
    var sumTransaction: Double {
        fetchedTransaction.reduce(0) { $0 + $1.sumTransaction }
    }
    
    
    var arrayTransactions: Array<Double> {
        fetchedTransaction.compactMap {Double($0.sumTransaction)}
    }
    
    
    var body: some View {
        NavigationView {
            //Text("")
//            PieChartView(data: [8,23,54,32], title: "Title", legend: "Legendary", dropShadow: false)
            VStack {

                Text("Statistics")
                
                
                
//                List {
//                    ForEach(fetchedCategory.filter{$0.isExpenses == true}) { category in
//                        HStack {
//                            ZStack {
//                                Circle()
//                                    .fill(Color(category.colorCategory ?? "swatch_articblue"))
//                                    .frame(width: 32, height: 32)
//                                Image(systemName: category.iconCategory ?? "creditcard.fill")
//                                    .foregroundColor(Color.white)
//                                    .font(Font.footnote)
//                            }
//
//                            VStack(alignment: .leading) {
//                                Text(category.nameCategory ?? "")
//                                    .bold()
//                                    .foregroundColor(.primary)
//
//                            }
//                            Spacer()
//                            Text("12")
//                                .font(.footnote)
//
//                        }
//
//                    }
//                }
            
            }
            //
            .navigationTitle(Text("Statistics"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                    
                }
            }
        }
        
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
