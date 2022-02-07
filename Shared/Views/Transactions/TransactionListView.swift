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
    @ObservedObject var categoryListItem: CategoryEntity
    @EnvironmentObject var accountListVM: AccountViewModel
    
    @State private var showingNewTransaction = false
    @State private var isEdit = false
    
    var body: some View {
        List {
            ForEach(self.accountListItem.transaction, id: \.self) { item in
                TransactionCallView(transaction: item, account: accountListItem, category: categoryListItem)
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
            NewAccountView(showAddAccount: $isEdit)
        }
        .sheet(isPresented: $showingNewTransaction) {
            NewTransactionView(showAddTransaction: $showingNewTransaction, accountSelect: accountListItem)
        }
        
    }
}

struct TransactionListView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionListView(accountListItem: AccountEntity(), categoryListItem: CategoryEntity())
    }
}
