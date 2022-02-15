//
//  AccountsView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 09.02.2022.
//

import SwiftUI

struct AccountsView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: AccountEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \AccountEntity.nameAccount, ascending: true)])
    private var fetchedAccount: FetchedResults<AccountEntity>
    
    
    @FetchRequest(entity: TransactionEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \TransactionEntity.sumTransaction, ascending: true)])
    private var fetchedTransaction: FetchedResults<TransactionEntity>
    
    @ObservedObject var accountItem: AccountEntity
    @EnvironmentObject var accountVM: AccountViewModel
    
    @State private var isNewAccount = false
    @State private var isNewTransaction = false
    
    var body: some View {
        NavigationView {
            VStack {
                if fetchedAccount.count == 0 {
                    // Если нет счетов отображается пустой экран
                    VStack {
                        Image(systemName: "tray.2.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.gray)
                        Text("Нет счетов!")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding()
                        Text("Для добавление нового счёта нажмите на кнопку ниже.")
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
                                Text("Новый счёт").bold()
                            }
                            .frame(width: 200, height: 40)
                        }.buttonStyle(.borderedProminent)
                            .padding()
                    }
                }
                else {
                    AccountsListView()
                        .safeAreaInset(edge: .bottom) {
                            PanelView()
                        }
                }
            }
            
            
            .navigationTitle("Мои счета")
            .navigationViewStyle(StackNavigationViewStyle())
            .toolbar {
                // Кнопка Настройки в NavigationView
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape")
                    }
                }
            }
            
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
