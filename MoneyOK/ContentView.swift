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
    
    @EnvironmentObject var accountVM: AccountViewModel
    @EnvironmentObject var transactionVM: TransactionViewModel
    
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    
    @State private var selectedTransaction: TransactionEntity?
    
    @State private var searchText = ""
    
    // Сумма всех транзакций выбраного счёта
    var sumTransactionForAccount: Double {
        accountVM.accountItem.transaction.reduce(0) { $0 + $1.sumTransaction }
    }
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            if !fetchedAccounts.isEmpty {
            //
                List(fetchedAccounts, selection: $accountVM.accountItem) {_ in
                if searchText.isEmpty {
                    if !(fetchedAccounts.filter{$0.isFavorite == true}).isEmpty {
                        Section("Favorites") {
                            ForEach(fetchedAccounts.filter{$0.isFavorite == true && $0.isArchive == false}) { (account: AccountEntity) in
                                NavigationLink(value: account)
                                {
                                    AccountCallView(accountItem: account)
                                }
                            }
                        }
                    }
                    
                    if !(fetchedAccounts.filter{$0.isFavorite == false && $0.isArchive == false}).isEmpty {
                        Section(fetchedAccounts.count <= 1 ? "Account" : "Accounts") {
                            ForEach(fetchedAccounts.filter{$0.isFavorite == false && $0.isArchive == false}) { (account: AccountEntity) in
                                NavigationLink(value: account)
                                {
                                    AccountCallView(accountItem: account)
                                }
                            }
                        }
                    }
                    
                    if !(fetchedAccounts.filter{$0.isArchive == true}).isEmpty {
                        Section("Archive") {
                            ForEach(fetchedAccounts.filter{$0.isArchive == true}) { (account: AccountEntity) in
                                NavigationLink(value: account)
                                {
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
            .searchable(text: $searchText, placement: .sidebar)
            .onChange(of: searchText) { newValue in
                fetchedTransaction.nsPredicate = searchPredicate(query: newValue)
            }
            .navigationTitle("Accounts")
            //
            //.navigationSplitViewColumnWidth(200)
            } else {
                NotAccountsView()
            }
            
        } content: {
            
            if (accountVM.accountItem != nil) {
                List(accountVM.accountItem.transaction, selection: $transactionVM.transactionItem) { transaction in
                    NavigationLink(value: transaction)
                    {
                        TransactionCallView(transactionItem: transaction)
                    }
                }
                
                .toolbar {
                    // Отображение название счёта и остаток по счёту
                    ToolbarItem(placement: .principal) {
                        VStack {
                            Text(accountVM.accountItem.nameAccount ?? "")
                                .font(.headline)
                                .foregroundColor(Color(accountVM.accountItem.colorAccount ?? ""))
                            Text("\(sumTransactionForAccount, format: .currency(code: "USD"))").font(.subheadline)
                        }
                    }
                }
            } else {
                NotTransactionsView()
            }
            
            //.navigationSplitViewColumnWidth(min: 400, ideal: 450, max:  500)
            
        } detail: {
            if transactionVM.transactionItem != nil {
                TransactionDetailView(transactionItem: transactionVM.transactionItem)
            } else {
                Text("Selected transaction")
            }
            
            
        }
        .navigationSplitViewStyle(.balanced)
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



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
