//
//  ContentView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 15.02.2023.
//

import SwiftUI
import CoreData


struct ContentView: View {
    
#if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
#endif
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors:
                    [
                        SortDescriptor(\AccountEntity.nameAccount, order: .reverse)
                    ])
    private var fetchedAccounts: FetchedResults<AccountEntity>
    
    @FetchRequest(sortDescriptors:
                    [
                        SortDescriptor(\TransactionEntity.dateTransaction)
                    ])
    
    private var fetchedTransaction: FetchedResults<TransactionEntity>
    
    @EnvironmentObject var accountVM: AccountViewModel
    @EnvironmentObject var transactionVM: TransactionViewModel
    
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    
    @State private var activeSheet: ActiveSheet?
    
    @State private var searchText = ""

    //
    @SectionedFetchRequest(
        sectionIdentifier: \.sections,
        sortDescriptors: [SortDescriptor(\TransactionEntity.dateTransaction, order: .reverse)],
        animation: .default)
    
    private var transactions: SectionedFetchResults<String, TransactionEntity>
    
    //
    
    // Сумма всех транзакций выбраного счёта
    var sumTransactionForAccount: Double {
        accountVM.accountSelect.transaction.reduce(0) { $0 + $1.sumTransaction }
    }
    
    var body: some View {
    
        NavigationSplitView(columnVisibility: $columnVisibility) {
            
            if !fetchedAccounts.isEmpty {
                
                List(selection: $accountVM.accountSelect) {
                    
                    // TODO: Додати як в нагадуваннях
                    
                    if searchText.isEmpty {
                        
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
                        
                    } else {
                            if fetchedTransaction.isEmpty {
                                Text("Not result") // TODO: Зробити прикольне вікно що немає результату
                            } else {
                                Section("Search results"){
                                ForEach(fetchedTransaction, id: \.self) { account in
                                    TransactionCallView(transactionItem: account)
                                }
                            }
                            }
                        }
                }
                .searchable(text: $searchText, placement: .sidebar)
                .onChange(of: searchText) { newValue in
                        fetchedTransaction.nsPredicate = searchPredicate(query: newValue)
                    }
                .listStyle(.insetGrouped)
                //.navigationTitle("Accounts")
                
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
                        if horizontalSizeClass == .compact {
                            if !fetchedAccounts.isEmpty {
                                Button {
                                    accountVM.accountSelect = nil
                                    activeSheet = .transaction
                                } label: {
                                    HStack {
                                        Image(systemName: "plus.circle.fill")
                                        Text("Transaction")
                                    }.fontWeight(.bold)
                                }
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
                        TransactionNewView()
                    }
                }
                
            } else {
                NotAccountsView()
            }
            
        } content: {
            
            VStack {
                if (accountVM.accountSelect != nil) {
                    Text("\(sumTransactionForAccount, format: .currency(code: "USD"))")
                        .foregroundColor(Color(accountVM.accountSelect.colorAccount ?? "swatch_gunsmoke"))
                        .font(.system(size: 24, weight: .bold, design: .default))
                    
                    List(accountVM.accountSelect.transaction.sorted(by: { $0.dateTransaction! > $1.dateTransaction! }), selection: $transactionVM.transactionItem) { transaction in
                        
                        NavigationLink(value: transaction)
                        {
                            TransactionCallView(transactionItem: transaction)
                        }
                    }
                } else {
                    NotTransactionsView()
                }
            }
            
            //.listStyle(.insetGrouped)
            .navigationBarTitle(accountVM.accountSelect?.nameAccount ?? "")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $activeSheet) { item in
                switch item {
                case .newAccount:
                    AccountNewView()
                case .settings:
                    SettingsView()
                case .statistics:
                    StatisticsView()
                case .transaction:
                    TransactionNewView()
                }
            }
            .toolbar {
                /// Кнопки створення нового рахунку та транзакції
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Menu {
                        /// Favorite
                        if accountVM.accountSelect?.isArchive == false {
                            Button {
                                accountVM.isFavorite(account: accountVM.accountSelect, context: viewContext)
                            } label: {
                                Label("Favorite", systemImage: accountVM.accountSelect.isFavorite ? "heart.slash" : "heart")
                            }
                        }
                        /// Archive
                        Button {
                            accountVM.isArchive(account: accountVM.accountSelect, context: viewContext)
                            if accountVM.accountSelect.isFavorite == true {
                                accountVM.isFavorite(account: accountVM.accountSelect, context: viewContext)
                            }
                            
                        } label: {
                            Label(accountVM.accountSelect?.isArchive ?? false ? "Unarchive" : "Archive", systemImage: accountVM.accountSelect?.isArchive ?? false ? "archivebox.fill" : "archivebox")
                        }
                    } label: {
                        Label("", systemImage: "ellipsis.circle")
                    }
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    if !fetchedAccounts.isEmpty {
                        Button {
                            activeSheet = .transaction
                        } label: {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Transaction")
                            }.fontWeight(.bold)
                                .foregroundColor(Color(accountVM.accountSelect?.colorAccount ?? "swatch_gunsmoke"))
                        }
                        Spacer()
                    }
                }
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
        return NSPredicate(format: "%K CONTAINS[cd] %@", argumentArray: [#keyPath(TransactionEntity.noteTransaction), query])
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
