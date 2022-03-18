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
    @FetchRequest(entity: TransactionEntity.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \TransactionEntity.dateTransaction, ascending: true)])
    private var fetchedTransaction: FetchedResults<TransactionEntity>

    @FetchRequest(sortDescriptors: [
        SortDescriptor(\TransactionEntity.dateTransaction, order: .reverse)
    ]) var books: FetchedResults<TransactionEntity>
    
    
    @SectionedFetchRequest(
        sectionIdentifier: \.sections,
        sortDescriptors: [SortDescriptor(\TransactionEntity.dateTransaction, order: .reverse)],
        animation: .default)
    
    private var transactions: SectionedFetchResults<String, TransactionEntity>


    //
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
                Text("No transactions!")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                Text("To add a new transaction, select the account and create a transaction.")
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
                }.listStyle(SidebarListStyle())
                

                
                Text("Total \(fetchedTransaction.count) transactions")
                Text("In total \(sumTransaction, format: .currency(code: Locale.current.currencyCode ?? "USD"))")
           }
            
        }
        
        .navigationTitle("All Transactions")
    }
}

struct TransactionAllListView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionAllListView()
    }
}
