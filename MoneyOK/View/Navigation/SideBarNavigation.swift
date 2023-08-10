//
//  SideBarNavigation.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 10/08/2023.
//

import SwiftUI

struct SideBarNavigation: View {
    
#if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
#endif
    
    @EnvironmentObject var accountVM: AccountViewModel
    
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
    
    @State private var activeSheet: ActiveSheet?
    
    var body: some View {
        NavigationSplitView {
            AccountsView()
                .toolbar {
                    /// Кнопка Настройки
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            activeSheet = .settings
                        } label: {
                            Image(systemName: "gearshape")
                        }
                    }
                    /// Кнопка Cтатистика
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
                        Spacer()
                        Button {
                            accountVM.clean()
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
                        Text("transaction")
                    }
                }
        } detail: {
            if accountVM.accountSelect != nil {
                TransactionsView(accountItem: accountVM.accountSelect)
            } else {
                Text("Select the account")
            }
        }.navigationSplitViewStyle(.balanced)
        
        
    }
    
}

struct SideBarNavigation_Previews: PreviewProvider {
    static var previews: some View {
        SideBarNavigation()
    }
}
