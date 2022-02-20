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
    
    //
    @FetchRequest(entity: TransactionEntity.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \TransactionEntity.transactionToCategory?.nameCategory, ascending: true)])
    private var fetchedTransaction: FetchedResults<TransactionEntity>
    
    //
    
    @SectionedFetchRequest(
        sectionIdentifier: \TransactionEntity.dateTransaction!,
        sortDescriptors: [SortDescriptor(\TransactionEntity.dateTransaction, order: .reverse)])
    
    private var transactions: SectionedFetchResults<Date, TransactionEntity>
    
    
    @State private var query = ""
    
    var body: some View {
        
        List {
            if query.isEmpty {
                if !(fetchedAccounts.filter{$0.isFavorite == true}).isEmpty {
                    Section("Избранные") {
                        ForEach(fetchedAccounts.filter{$0.isFavorite == true && $0.isArchive == false}) { (account: AccountEntity) in
                            NavigationLink(destination:
                                            TransactionsView(accountItem: account).environment(\.managedObjectContext, self.viewContext))
                            {
                                AccountCallView(accountItem: account)
                            }
                            //.isDetailLink(false) // Исправляет баг с tabbar в списке транзакций
                            .swipeActions() {}
                        }
                    }
                }
                
                Section(fetchedAccounts.count <= 1 ? "Счёт" : "Счета") {
                    ForEach(fetchedAccounts.filter{$0.isFavorite == false && $0.isArchive == false}) { (account: AccountEntity) in
                        NavigationLink(destination:
                                        TransactionsView(accountItem: account).environment(\.managedObjectContext, self.viewContext))
                        {
                            AccountCallView(accountItem: account)
                        }
                        //.isDetailLink(false) // Исправляет баг с tabbar в списке транзакций
                        .swipeActions() {}
                    }
                }
                if !(fetchedAccounts.filter{$0.isArchive == true}).isEmpty {
                    Section("Архив") {
                        ForEach(fetchedAccounts.filter{$0.isArchive == true}) { (account: AccountEntity) in
                            NavigationLink(destination:
                                            TransactionsView(accountItem: account).environment(\.managedObjectContext, self.viewContext))
                            {
                                AccountCallView(accountItem: account)
                            }
                            //.isDetailLink(false) // Исправляет баг с tabbar в списке транзакций
                            .swipeActions() {}
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
                    .swipeActions() {}
                }
            }
            
        }
        .searchable(text: $query, placement: .sidebar)
        .onChange(of: query) { newValue in
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
