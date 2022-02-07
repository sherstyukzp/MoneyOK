//
//  AccountCallView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 21.01.2022.
//

import SwiftUI

struct AccountCallView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var accountVM: AccountViewModel
    
    @ObservedObject var accountListItem: AccountEntity
    
    @State private var isEditAccount = false
    @State private var isNewTransaction = false
    

    
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
                self.isNewTransaction.toggle()
            } label: {
                Label("Новая транзакция", systemImage: "plus.circle")
            }
            
            Divider()
            if accountListItem.isArchive == false {
                Button {
                    accountVM.isFavorite(account: accountListItem, context: viewContext)
                } label: {
                    Label("Избранный", systemImage: accountListItem.isFavorite ? "heart.slash" : "heart")
                }
            }
            
            Button {
                accountVM.nameAccountSave = accountListItem.nameAccount!
                accountVM.iconAccountSave = accountListItem.iconAccount!
                accountVM.colorAccountSave = accountListItem.colorAccount!
                accountVM.balanceAccountSave = accountListItem.balanceAccount
                accountVM.noteAccountSave = accountListItem.noteAccount!
                accountVM.accountListItem = accountListItem
                self.isEditAccount.toggle()
            } label: {
                Label("Редактировать", systemImage: "highlighter")
            }
            
            Button {
                accountVM.isArchive(account: accountListItem, context: viewContext)
                if accountListItem.isFavorite == true {
                    accountVM.isFavorite(account: accountListItem, context: viewContext)
                }
                
            } label: {
                Label(accountListItem.isArchive ? "Разархивировать" : "Архивировать", systemImage: accountListItem.isArchive ? "archivebox.fill" : "archivebox")
            }
            Divider()
            Button(role: .destructive) {
                accountVM.delete(account: accountListItem, context: viewContext)
            } label: {
                Label("Удалить", systemImage: "trash")
            }
        }
        .sheet(isPresented: $isEditAccount) {
            NewAccountView(isAddAccount: $isEditAccount)
        }
        .sheet(isPresented: $isNewTransaction) {
            NewTransactionView(showAddTransaction: $isNewTransaction)
            }
        // Свайп влево
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            if accountListItem.isArchive == false {
                Button {
                    accountVM.isFavorite(account: accountListItem, context: viewContext)
                } label: {
                    Label("Избранный", systemImage: accountListItem.isFavorite ? "heart.slash" : "heart")
                }.tint(.green)
            }
            
            
            Button {
                accountVM.isArchive(account: accountListItem, context: viewContext)
                if accountListItem.isFavorite == true {
                    accountVM.isFavorite(account: accountListItem, context: viewContext)
                }
                
            } label: {
                Label("Архивировать", systemImage: accountListItem.isArchive ? "archivebox.fill" : "archivebox")
            }.tint(.gray)
            
        }
        // Свайп вправо
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
                accountVM.delete(account: accountListItem, context: viewContext)
            } label: {
                Label("Удалить", systemImage: "trash")
            }
            
            Button {
                accountVM.nameAccountSave = accountListItem.nameAccount!
                accountVM.iconAccountSave = accountListItem.iconAccount!
                accountVM.colorAccountSave = accountListItem.colorAccount!
                accountVM.balanceAccountSave = accountListItem.balanceAccount
                accountVM.noteAccountSave = accountListItem.noteAccount!
                accountVM.accountListItem = accountListItem
                self.isEditAccount.toggle()
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
