//
//  AccountsView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 09.02.2022.
//

import SwiftUI

struct AccountsView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.nameAccount, order: .forward)])
    private var fetchedAccount: FetchedResults<AccountEntity>
    
    
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\TransactionEntity.dateTransaction, order: .reverse)
    ]) var fetchedTransaction: FetchedResults<TransactionEntity>
    
    @State private var activeSheet: ActiveSheet?
    @State private var isNewTransaction = false
    
    var body: some View {
        NavigationStack {
            if fetchedAccount.isEmpty {
                NotAccountsView()
                
            }
            else {
                AccountsListView()
            }
        }
        
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
                    
                        if !fetchedAccount.isEmpty {
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
                    TransactionNewView(accountItem: fetchedAccount.first!, nowAccount: false)
                }
            }
        
            
    }
}

struct AccountsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsView()
    }
}
