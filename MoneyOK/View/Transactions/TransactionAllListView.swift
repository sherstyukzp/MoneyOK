//
//  TransactionAllListView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 13.02.2022.
//

import SwiftUI



struct TransactionAllListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: TransactionEntity.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \TransactionEntity.dateTransaction, ascending: true)])
    private var fetchedTransaction: FetchedResults<TransactionEntity>
    
//    @SectionedFetchRequest(
//        sectionIdentifier: \TransactionEntity.transactionToCategory!.nameCategory!,
//        sortDescriptors: [SortDescriptor(\TransactionEntity.transactionToCategory?.nameCategory, order: .reverse)])
    
    @SectionedFetchRequest(
        sectionIdentifier: \TransactionEntity.dateTransaction!,
        sortDescriptors: [SortDescriptor(\TransactionEntity.dateTransaction, order: .reverse)])
    
    private var transactions: SectionedFetchResults<Date, TransactionEntity>

    // Складывает все транзакции
    var sumTransaction: Double {
        fetchedTransaction.reduce(0) { $0 + $1.sumTransaction }
    }

    
    var body: some View {
        VStack {
            if fetchedTransaction.isEmpty {
                Image(systemName: "tray.2.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.gray)
                Text("Нет транзакций!")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                Text("Для добавление новой транзакции выберите счёт и создайте транзакцию.")
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30.0)
            } else {
                List {
                    ForEach(transactions) { section in
                        Section(header: Text(section.id, style: .date)) {
                            ForEach(section) { item in
                                NavigationLink(destination:
                                                TransactionDetailView(transactionItem: item))
                                {
                                    TransactionCallView(transactionItem: item)
                                }
                                .swipeActions() {
                                }
                            }
                        }
                    }
                }
                

                
                Text("Всего \(fetchedTransaction.count) транзакций")
                Text("На сумму \(sumTransaction, format: .currency(code: Locale.current.currencyCode ?? "USD"))")
           }
            
        }
        
        .navigationTitle("Все транзакции")
    }
}

struct TransactionAllListView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionAllListView()
    }
}
