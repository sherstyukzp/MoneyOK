//
//  TransactionAllListView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 13.02.2022.
//

import SwiftUI

extension TransactionEntity {
    
    @objc
    public var sections: String {
        // I used the base Xcode core data app which has timestamp as an optional.
        // You can remove the unwrapping if your dates are not optional.
        if let timestamp = dateTransaction {
            // This sets up the RelativeDateTimeFormatter
            let rdf = RelativeDateTimeFormatter()
            // This gives the verbose response that you are looking for.
            rdf.unitsStyle = .spellOut
            // This gives the relative time in names like today".
            rdf.dateTimeStyle = .named

            // If you are happy with Apple's choices. uncomment the line below
            // and remove everything else.
  //        return rdf.localizedString(for: timestamp, relativeTo: Date())
            
            // You could also intercept Apple's labels for you own
            switch rdf.localizedString(for: timestamp, relativeTo: Date()) {
            case "now":
                return "today"
            case "in two days", "in three days", "in four days", "in five days", "in six days", "in seven days":
                return "this week"
            default:
                return rdf.localizedString(for: timestamp, relativeTo: Date())
            }
        }
        // This is only necessary with an optional date.
        return "undated"
    }
}

struct TransactionAllListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: TransactionEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \TransactionEntity.dateTransaction, ascending: true)])
    private var fetchedTransaction: FetchedResults<TransactionEntity>
    
    @SectionedFetchRequest(
        sectionIdentifier: \TransactionEntity.transactionToCategory!.nameCategory!,
        sortDescriptors: [SortDescriptor(\TransactionEntity.transactionToCategory?.nameCategory, order: .reverse)])
    private var transactions: SectionedFetchResults<String, TransactionEntity>

    
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
                        Section(header: Text(section.id.capitalized)) {
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
