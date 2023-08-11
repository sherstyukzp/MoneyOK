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
            rdf.unitsStyle = .full
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
    
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\TransactionEntity.dateTransaction, order: .reverse)
    ]) var fetchedTransaction: FetchedResults<TransactionEntity>
    
    
    @SectionedFetchRequest(
        sectionIdentifier: \.sections,
        sortDescriptors: [SortDescriptor(\TransactionEntity.dateTransaction, order: .reverse)],
        animation: .default)
    
    private var transactions: SectionedFetchResults<String, TransactionEntity>
    
    @State private var isShareSheetShowing = false
    //
    // Складывает все транзакции
    var sumTransaction: Double {
        fetchedTransaction.reduce(0) { $0 + $1.sumTransaction }
    }
    
    
    var body: some View {
        VStack {
            if fetchedTransaction.isEmpty {
                NotTransactionsView()
            } else {
                List {
                    ForEach(transactions) { section in
                        Section {
                            ForEach(section) { item in
                                
                                NavigationLink(destination:
                                                TransactionDetailView(transactionItem: item))
                                {
                                    TransactionCallView(transactionItem: item)
                                }
                                
                            }
                        } header: {
                            Text(section.id.capitalized)
                        }
                        
                    }
                }.listStyle(SidebarListStyle())
                
                VStack {
                    HStack {
                        Text("Total")
                        Text("\(fetchedTransaction.count)")
                        Text("transactions")
                    }
                    HStack {
                        Text("In total")
                        Text("\(sumTransaction)")
                    }
                }
                
                
                    
            }
            
        }
        .toolbar {
            if !fetchedTransaction.isEmpty {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        // Экспорт транзакций
                        Button {
                            shareButton()
                        } label: {
                            Label("Export CSV", systemImage: "square.and.arrow.up")
                        }
                    }
                label: {
                    Label("Menu", systemImage: "ellipsis.circle")
                }
                }
            }
        }
        
        .navigationTitle("All Transactions")
    }
    
    func shareButton() {
        let fileName = "MoneyOK.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        var csvText = "Date,Account,Category,Sun,Note\n"
        
        for transaction in fetchedTransaction {
            csvText += "\(transaction.dateTransaction ?? Date()),\(transaction.transactionToAccount?.nameAccount ?? ""),\(transaction.transactionToCategory?.nameCategory ?? ""),\(transaction.sumTransaction),\(transaction.noteTransaction ?? "not note")\n"
        }
        
        do {
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
        print(path ?? "not found")
        
        var filesToShare = [Any]()
        filesToShare.append(path!)
        
        let av = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
        
              if let vc = UIApplication.shared.windows.first?.rootViewController{
                  av.popoverPresentationController?.sourceView = vc.view
                 //Setup share activity position on screen on bottom center
                  av.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height, width: 0, height: 0)
                  av.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
                 vc.present(av, animated: true, completion: nil)
              }
        
        isShareSheetShowing.toggle()
    }
    
}

struct TransactionAllListView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionAllListView()
    }
}
