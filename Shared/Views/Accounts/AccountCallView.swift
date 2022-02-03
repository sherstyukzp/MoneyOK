//
//  AccountCallView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 21.01.2022.
//

import SwiftUI

struct AccountCallView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var accountListVM: AccountViewModel
    
    @ObservedObject var accountListItem: AccountEntity
    
    @State private var isEdit = false
    @State private var showingNewTransaction = false
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(Color((accountListItem.isArchive ? "swatch_gunsmoke" : accountListItem.colorAccount) ?? "swatch_gunsmoke"))
                    .frame(width: 32, height: 32)
                Image(systemName: accountListItem.iconAccount ?? "plus")
                    .foregroundColor(Color.white)
                    .font(Font.footnote)
            }
            
            VStack(alignment: .leading) {
                Text(accountListItem.nameAccount ?? "no name")
                    .bold()
                    .foregroundColor(accountListItem.isArchive ? .gray : .primary)
                Text("Баланс: \(accountListItem.balanceAccount)").font(Font.footnote).foregroundColor(Color.gray)
            }
            
        }
        .contextMenu {
            Button {
                self.showingNewTransaction.toggle()
            } label: {
                Label("Новая транзакция", systemImage: "plus.circle")
            }
            
            Divider()
            if accountListItem.isArchive == false {
                Button {
                    accountListVM.isFavorite(account: accountListItem, context: viewContext)
                } label: {
                    Label("Избранный", systemImage: accountListItem.isFavorite ? "heart.slash" : "heart")
                }
            }
            
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
            
            Button {
                accountListVM.isArchive(account: accountListItem, context: viewContext)
                if accountListItem.isFavorite == true {
                    accountListVM.isFavorite(account: accountListItem, context: viewContext)
                }
                
            } label: {
                Label(accountListItem.isArchive ? "Разархивировать" : "Архивировать", systemImage: accountListItem.isArchive ? "archivebox.fill" : "archivebox")
            }
            Divider()
            Button(role: .destructive) {
                accountListVM.delete(account: accountListItem, context: viewContext)
            } label: {
                Label("Удалить", systemImage: "trash")
            }
        }
        .sheet(isPresented: $isEdit) {
            NewAccountView(showAdd: $isEdit)
        }
        .sheet(isPresented: $showingNewTransaction) {
                NewTransactionView(showAddTransaction: $showingNewTransaction)
            }
        // Свайп влево
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            if accountListItem.isArchive == false {
                Button {
                    accountListVM.isFavorite(account: accountListItem, context: viewContext)
                } label: {
                    Label("Избранный", systemImage: accountListItem.isFavorite ? "heart.slash" : "heart")
                }.tint(.green)
            }
            
            
            Button {
                accountListVM.isArchive(account: accountListItem, context: viewContext)
                if accountListItem.isFavorite == true {
                    accountListVM.isFavorite(account: accountListItem, context: viewContext)
                }
                
            } label: {
                Label("Архивировать", systemImage: accountListItem.isArchive ? "archivebox.fill" : "archivebox")
            }.tint(.gray)
            
        }
        // Свайп вправо
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
                accountListVM.delete(account: accountListItem, context: viewContext)
            } label: {
                Label("Удалить", systemImage: "trash")
            }
            
            Button {
                accountListVM.nameAccountSave = accountListItem.nameAccount!
                accountListVM.iconAccountSave = accountListItem.iconAccount!
                accountListVM.colorAccountSave = accountListItem.colorAccount!
                accountListVM.balanceAccountSave = accountListItem.balanceAccount
                accountListVM.noteAccountSave = accountListItem.noteAccount!
                accountListVM.accountListItem = accountListItem
                self.isEdit.toggle()
            } label: {
                Label("Редактировать", systemImage: "pencil")
            }.tint(.yellow)
            
        }
        
    }
}

struct AccountCallView_Previews: PreviewProvider {
    static var previews: some View {
        AccountCallView(accountListItem: AccountEntity())
        
    }
}
