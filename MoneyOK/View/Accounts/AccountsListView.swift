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
    
    @State private var query = ""
    
    var body: some View {
        List {
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
        .searchable(text: $query, prompt: "Поиск счёта")
            .onChange(of: query) { newValue in
                fetchedAccounts.nsPredicate = searchPredicate(query: newValue)
            }
        
    }
    
    
    private func searchPredicate(query: String) -> NSPredicate? {
        if query.isEmpty { return nil }
        return NSPredicate(format: "%K BEGINSWITH[cd] %@",
                           #keyPath(AccountEntity.nameAccount), query)
      }
    
    
    
}

struct AccountsListView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsListView()
    }
}
