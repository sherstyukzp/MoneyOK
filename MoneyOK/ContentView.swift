//
//  ContentView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 15.02.2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors:
                    [
                        SortDescriptor(\AccountEntity.nameAccount, order: .reverse)
                    ])
    private var fetchedAccounts: FetchedResults<AccountEntity>
    
    @FetchRequest(sortDescriptors:
                    [
                        SortDescriptor(\TransactionEntity.transactionToCategory?.nameCategory, order: .reverse)
                    ])
    
    private var fetchedTransaction: FetchedResults<TransactionEntity>
    
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    @State private var selectedAccount: AccountEntity?
    @State private var selectedTransaction: TransactionEntity?
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(fetchedAccounts, selection: $selectedAccount) { book in
                NavigationLink(value: book) {
                    Text(book.nameAccount ?? "Not sected")
                }
            }
            //.navigationSplitViewColumnWidth(200)
            .navigationSplitViewStyle(.balanced)
            .navigationTitle("Accounts")
            
        } content: {
            
            if (selectedAccount != nil) {
                List(selectedAccount?.transaction ?? [], selection: $selectedTransaction) { chapter in
                    NavigationLink(value: chapter) {
                        Text(chapter.transactionToCategory?.nameCategory ?? "")
                    }
                }
                .navigationTitle("Transactions")
            } else {
                Text("Selected account")
            }
            
            //.navigationSplitViewColumnWidth(min: 400, ideal: 450, max:  500)
            
        } detail: {
            if selectedTransaction != nil {
                Text("\(selectedTransaction?.sumTransaction ?? 0)" )
                    .padding()
                    .navigationTitle(selectedTransaction?.transactionToCategory?.nameCategory ?? "")
            } else {
                Text("Selected transaction")
            }
            
            
        }
        .navigationSplitViewStyle(.balanced)
        
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
