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
    
    @State private var activeSheet: ActiveSheet?
    
    @State private var searchText = ""
    
    // Сумма всех транзакций выбраного счёта
    var sumTransactionForAccount: Double {
        accountVM.accountItem.transaction.reduce(0) { $0 + $1.sumTransaction }
    }
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            if !fetchedAccounts.isEmpty {
                
                List(selection: $accountVM.accountItem) {
                    
                    if !(fetchedAccounts.filter{$0.isFavorite == true}).isEmpty {
                        Section("Favorites") {
                            ForEach(fetchedAccounts.filter{$0.isFavorite == true && $0.isArchive == false}) { account in
                                NavigationLink(value: account)
                                {
                                    AccountCallView(accountItem: account)
                                }
                            }
                        }
                    }
                    
                    Section(fetchedAccounts.count <= 1 ? "Account" : "Accounts") {
                        ForEach(fetchedAccounts.filter{$0.isFavorite == false && $0.isArchive == false}) { account in
                            NavigationLink(value: account)
                            {
                                AccountCallView(accountItem: account)
                            }
                        }
                    }
                    if !(fetchedAccounts.filter{$0.isArchive == true}).isEmpty {
                        Section("Archive") {
                            ForEach(fetchedAccounts.filter{$0.isArchive == true}) { account in
                                NavigationLink(value: account)
                                {
                                    AccountCallView(accountItem: account)
                                }
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .navigationTitle("Accounts")
                
                .toolbar {
                    /// Кнопка Настройки в NavigationView
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            activeSheet = .settings
                        } label: {
                            Image(systemName: "gearshape")
                        }
                    }
                    /// Кнопка статистика в NavigationView
                    ToolbarItem(placement: .navigationBarLeading) {
                        if !fetchedTransaction.isEmpty {
                            Button {
                                activeSheet = .statistics
                            } label: {
                                Image(systemName: "chart.xyaxis.line")
                            }
                        }
                    }
                    /// Кнопки створення нового рахунку та транзакції
                    ToolbarItemGroup(placement: .bottomBar) {
                        
                            if !fetchedAccounts.isEmpty {
                                Button {
                                    activeSheet = .transaction
                                } label: {
                                    HStack {
                                        Image(systemName: "plus.circle.fill")
                                        Text("Transaction")
                                    }.fontWeight(.bold)
                                }
                            }
                                
                                Spacer()
                                Button {
                                    activeSheet = .newAccount
                                } label: {
                                    Text("New account")
                                }
                            
                    }
                }
            
                .sheet(item: $activeSheet) { item in
                    switch item {
                    case .newAccount:
                        AccountNewView()
                    case .settings:
                        SettingsView()
                    case .statistics:
                        StatisticsView()
                    case .transaction:
                        TransactionNewView(accountItem: fetchedAccounts.first!, nowAccount: false)
                    }
                }
                
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
                .listStyle(.insetGrouped)
                
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
    
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
