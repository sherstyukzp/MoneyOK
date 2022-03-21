//
//  AccountsView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 09.02.2022.
//

import SwiftUI

struct AccountsView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
//    @FetchRequest(entity: AccountEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \AccountEntity.nameAccount, ascending: true)])
//    private var fetchedAccount: FetchedResults<AccountEntity>
    
    // iOS 15
    @FetchRequest(sortDescriptors: [SortDescriptor(\.nameAccount, order: .forward)])
    private var fetchedAccount: FetchedResults<AccountEntity>
    
    
    @ObservedObject var accountItem: AccountEntity
    @EnvironmentObject var accountVM: AccountViewModel
    
    @State private var isNewAccount = false
    @State private var isNewTransaction = false
    @State private var isStatistics = false
    
    var body: some View {
        NavigationView {
            VStack {
                if fetchedAccount.count == 0 {
                    // Если нет счетов отображается пустой экран
                    VStack {
                        Image(systemName: "tray.2.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.gray)
                        Text("No accounts!")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding()
                        Text("To add a new account, click on the button below.")
                            .font(.subheadline)
                            .foregroundColor(Color.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30.0)
                        Button {
                            accountVM.nameAccountSave = ""
                            accountVM.noteAccountSave = ""
                            accountVM.accountItem = nil
                            self.isNewAccount.toggle()
                            
                        } label: {
                            HStack {
                                Image(systemName: "plus.circle.fill").font(.system(size: 22, weight: .bold))
                                Text("New account").bold()
                            }
                            .frame(width: 200, height: 40)
                        }.buttonStyle(.borderedProminent)
                            .padding()
                    }
                }
                else {
//                    HStack{
//                        ExpensesView().padding(.leading)
//                        ExpensesView().padding(.trailing)
//                    }
                    
                    AccountsListView()
                        .safeAreaInset(edge: .bottom) {
                            PanelView()
                        }
                }
            }
            
            
            .navigationTitle("My account")
            .navigationViewStyle(StackNavigationViewStyle())
            .toolbar {
                // Кнопка Настройки в NavigationView
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape")
                    }
                }
                
                // Кнопка статистика в NavigationView
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.isStatistics.toggle()
                    } label: {
                        Image(systemName: "chart.xyaxis.line")
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
}

struct AccountsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsView(accountItem: AccountEntity())
    }
}
