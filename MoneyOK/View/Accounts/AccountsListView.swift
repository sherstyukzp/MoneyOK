//
//  AccountsListView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 09.02.2022.
//

import SwiftUI
import CoreData

struct AccountsListView: View {
    
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
    
    @EnvironmentObject var accountVM: AccountViewModel
    
    @State private var searchText = ""
    
    var body: some View {
        
        List(selection: $accountVM.accountSelect) {
            if searchText.isEmpty {
                if !(fetchedAccounts.filter{$0.isFavorite == true}).isEmpty {
                    Section("Favorites") {
                        ForEach(fetchedAccounts.filter{$0.isFavorite == true && $0.isArchive == false}) { (account: AccountEntity) in
                            NavigationLink(destination: TransactionsView(accountItem: account)) {
                                AccountCallView(accountItem: account)
                            }
                        }
                    }
                }
                
                Section(fetchedAccounts.count <= 1 ? "Account" : "Accounts") {
                    ForEach(fetchedAccounts.filter{$0.isFavorite == false && $0.isArchive == false}) { (account: AccountEntity) in
                        NavigationLink(destination: TransactionsView(accountItem: account)) {
                            AccountCallView(accountItem: account)
                        }
                    }
                }
                if !(fetchedAccounts.filter{$0.isArchive == true}).isEmpty {
                    Section("Archive") {
                        ForEach(fetchedAccounts.filter{$0.isArchive == true}) { (account: AccountEntity) in
                            NavigationLink(destination: TransactionsView(accountItem: account)) {
                                AccountCallView(accountItem: account)
                            }
                        }
                    }
                }
            }
            else {
                if fetchedTransaction.isEmpty {
                    Text("Not result") // TODO: Зробити прикольне вікно що немає результату
                } else {
                    VStack {
                        Text("Total found: \(fetchedTransaction.count)")
                        ForEach(fetchedTransaction, id: \.self) { account in
                            NavigationLink(value: account)
                            {
                                TransactionCallView(transactionItem: account)
                            }
                            
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .searchable(text: $searchText, placement: .sidebar)
        .onChange(of: searchText) { newValue in
            fetchedTransaction.nsPredicate = searchPredicate(query: newValue)
        }
    }
    
    /// Пошук по назві транзакції
    /// - Parameter query: Запит
    /// - Returns: Результат пошуку
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
