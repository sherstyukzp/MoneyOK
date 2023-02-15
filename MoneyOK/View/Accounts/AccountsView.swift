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
    
    
    @State private var isNewAccount = false
    @State private var isNewTransaction = false
    @State private var isStatistics = false
    
    var body: some View {
        NavigationView {
            VStack {
                if fetchedAccount.isEmpty {
                    NotAccountsView()
                }
                else {
                    AccountsListView()
                }
            }
            
            .navigationTitle("My account")
        }
        .toolbar {
            // Кнопка Настройки в NavigationView
            ToolbarItem(placement: .navigationBarLeading) {
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gearshape")
                }
            }
            // Кнопка статистика в NavigationView
            ToolbarItem(placement: .navigationBarTrailing) {
                if !fetchedTransaction.isEmpty {
                    
                    Button {
                        self.isStatistics.toggle()
                    } label: {
                        Image(systemName: "chart.xyaxis.line")
                    }
                }
            }
            ToolbarItemGroup(placement: .bottomBar) {
                if !fetchedAccount.isEmpty {
                    HStack {
                        Button {
                            isNewTransaction.toggle()
                        } label: {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Transaction")
                            }.fontWeight(.bold)
                        }
                        Spacer()
                        Button {
                            isNewAccount.toggle()
                        } label: {
                            Text("New account")
                        }
                    }
                    
                }
            }
        }
        
        .fullScreenCover(isPresented: $isStatistics, content: StatisticsView.init)
        
        .sheet(isPresented: $isNewAccount) {
            AccountNewView(isNewAccount: $isNewAccount)
        }
        
        .sheet(isPresented: $isNewTransaction) {
            TransactionNewView(accountItem: fetchedAccount.first!, isNewTransaction: $isNewTransaction, nowAccount: false)
        }
        
        
    }
}

struct AccountsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsView()
    }
}
