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
    
    private let data: [Int] = Array(1...4)
    
    // Adaptive, make sure it's the size of your smallest element.
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 100, maximum: UIScreen.main.bounds.width / 2))
    ]
    
    // Flexible, custom amount of columns that fill the remaining space
    private let numberColumns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    // Fixed, creates columns with fixed dimensions
    private let fixedColumns = [
        GridItem(.fixed(200)),
        GridItem(.fixed(200))
    ]
    
    //.background(Color(UIColor.systemGroupedBackground))
    //.listRowBackground(Color(.secondarySystemBackground))
    
    var body: some View {
        
        List {
            if searchText.isEmpty {
                //                        LazyVGrid(columns: numberColumns, spacing: 10) {
                //                                    ForEach(data, id: \.self) { number in
                //                                        PanelView()
                //                                            .listRowBackground(Color(.secondarySystemBackground))
                //                                    }
                //                                }
                
                if !(fetchedAccounts.filter{$0.isFavorite == true}).isEmpty {
                    Section {
                        ForEach(fetchedAccounts.filter{$0.isFavorite == true && $0.isArchive == false}) { (account: AccountEntity) in
                            NavigationLink(destination: TransactionsView(accountItem: account)) {
                                AccountCallView(accountItem: account)
                            }
                        }
                    } header: {
                        HStack {
                            Image(systemName: "star")
                            Text("Favorites")
                        }
                    }
                }
                
                Section {
                    ForEach(fetchedAccounts.filter{$0.isFavorite == false && $0.isArchive == false}) { (account: AccountEntity) in
                        NavigationLink(destination: TransactionsView(accountItem: account)) {
                            AccountCallView(accountItem: account)
                        }
                    }
                } header: {
                    HStack {
                        Image(systemName: "creditcard")
                        Text(fetchedAccounts.count > 1 ? "Accounts" : "Account")
                    }
                    
                }
                if !(fetchedAccounts.filter{$0.isArchive == true}).isEmpty {
                    Section {
                        ForEach(fetchedAccounts.filter{$0.isArchive == true}) { (account: AccountEntity) in
                            NavigationLink(destination: TransactionsView(accountItem: account)) {
                                AccountCallView(accountItem: account)
                            }
                        }
                    } header: {
                        HStack {
                            Image(systemName: "archivebox")
                            Text("Archive")
                        }
                        
                    }
                }
            }
            else {
                if fetchedTransaction.isEmpty {
                    Text("Not result") // TODO: Зробити прикольне вікно що немає результату
                } else {
                    VStack {
                        HStack{
                            Text("Total found:")
                            Text("\(fetchedTransaction.count)")
                        }
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
        
        .listStyle(.sidebar)
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
