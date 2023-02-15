//
//  AccountsListView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 09.02.2022.
//

import SwiftUI
import CoreData

struct AccountsListView: View {
    
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
    
    
    @State private var searchText = ""
    
    var body: some View {
        List {
                if searchText.isEmpty {
                    if !(fetchedAccounts.filter{$0.isFavorite == true}).isEmpty {
                        Section("Favorites") {
                            ForEach(fetchedAccounts.filter{$0.isFavorite == true && $0.isArchive == false}) { (account: AccountEntity) in
                                NavigationLink(destination:
                                                TransactionsView(accountItem: account).environment(\.managedObjectContext, self.viewContext))
                                {
                                    AccountCallView(accountItem: account)
                                }
                            }
                        }
                    }
                    
                    Section(fetchedAccounts.count <= 1 ? "Account" : "Accounts") {
                        ForEach(fetchedAccounts.filter{$0.isFavorite == false && $0.isArchive == false}) { (account: AccountEntity) in
                            NavigationLink(destination:
                                            TransactionsView(accountItem: account).environment(\.managedObjectContext, self.viewContext))
                            {
                                AccountCallView(accountItem: account)
                            }
                        }
                    }
                    if !(fetchedAccounts.filter{$0.isArchive == true}).isEmpty {
                        Section("Archive") {
                            ForEach(fetchedAccounts.filter{$0.isArchive == true}) { (account: AccountEntity) in
                                NavigationLink(destination:
                                                TransactionsView(accountItem: account).environment(\.managedObjectContext, self.viewContext))
                                {
                                    AccountCallView(accountItem: account)
                                }
                            }
                        }
                    }
                }
                else {
                    ForEach(fetchedTransaction, id: \.self) { item in
                        NavigationLink(destination:
                                        TransactionDetailView(transactionItem: item))
                        {
                            TransactionCallView(transactionItem: item)
                        }
                    }
                }
            }
        
        .searchable(text: $searchText, placement: .sidebar)
        .onChange(of: searchText) { newValue in
            fetchedTransaction.nsPredicate = searchPredicate(query: newValue)
        }
        
    }
    
    
    private func searchPredicate(query: String) -> NSPredicate? {
        if query.isEmpty { return nil }
        return NSPredicate(format: "%K BEGINSWITH[cd] %@",
                           #keyPath(TransactionEntity.transactionToCategory.nameCategory), query)
    }
    
    
}

struct AccountsListView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsListView()
    }
}
