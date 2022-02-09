//
//  TransactionListView.swift
//  MoneyOK-iOS
//
//  Created by Ярослав Шерстюк on 03.02.2022.
//

import SwiftUI
import CoreData

struct TransactionListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    
    @ObservedObject var accountListItem: AccountEntity
    
    @EnvironmentObject var accountListVM: AccountViewModel
    
    @State private var showingNewTransaction = false
    @State private var isEdit = false
    
    var body: some View {
        
        VStack {
            if accountListItem.transaction.count == 0 {
                // Если нет счетов отображается пустой экран
                VStack {
                    Image(systemName: "tray.2.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.gray)
                    Text("Нет транзакций!")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding()
                    Text("Для добавление новой транзакци нажмите на плюс.")
                        .font(.subheadline)
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30.0)
                    
                }
            } else {
                List {
                    ForEach(self.accountListItem.transaction, id: \.self) { item in
                        TransactionCallView(transactionListItem: item, account: accountListItem)
                    }
                }
            }
        }
        
        
        
        
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(accountListItem.nameAccount ?? "")
                        .font(.headline)
                        .foregroundColor(Color(accountListItem.colorAccount ?? ""))
                    Text("\(accountListItem.balanceAccount)").font(.subheadline)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        accountListVM.nameAccountSave = accountListItem.nameAccount!
                        accountListVM.iconAccountSave = accountListItem.iconAccount!
                        accountListVM.colorAccountSave = accountListItem.colorAccount!
                        accountListVM.balanceAccountSave = accountListItem.balanceAccount
                        accountListVM.noteAccountSave = accountListItem.noteAccount!
                        accountListVM.accountListItem = accountListItem
                        self.isEdit.toggle()
                    } label: {
                        Label("Редактировать", systemImage: "highlighter")
                    }
                    
                    Divider()
                    Button(role: .destructive) {
                        accountListVM.delete(account: accountListItem, context: viewContext)
                    } label: {
                        Label("Удалить", systemImage: "trash")
                    }
                }
            label: {
                Label("Menu", systemImage: "ellipsis.circle")
            }
            }
            
            ToolbarItemGroup(placement: .bottomBar) {
                Button(action: {
                    self.showingNewTransaction.toggle()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .imageScale(.medium)
                        .font(.title)
                        .foregroundColor(Color(accountListItem.colorAccount ?? ""))
                    Text("Транзакция").bold()
                        .foregroundColor(Color(accountListItem.colorAccount ?? ""))
                }
                Spacer()
            }
        }
        .sheet(isPresented: $isEdit) {
            NewAccountView(isAddAccount: $isEdit)
        }
        .sheet(isPresented: $showingNewTransaction) {
            NewTransactionView(showAddTransaction: $showingNewTransaction)
        }
        
    }
}

struct TransactionListView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionListView(accountListItem: AccountEntity())
    }
}
