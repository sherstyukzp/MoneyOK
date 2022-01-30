//
//  AccountCallView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 21.01.2022.
//

import SwiftUI

struct AccountCallView: View {
    //    @State var colorAccount: String
    //    @State var iconAccount: String
    //    @State var nameAccount: String
    //    @State var balance: Double
    
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var accountListVM: AccountViewModel
    
    @ObservedObject var accountListItem: AccountEntity
    
    @State private var isEdit = false
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(Color(accountListItem.colorAccount ?? "swatch_asparagus" ))
                    .frame(width: 32, height: 32)
                Image(systemName: accountListItem.iconAccount ?? "plus" )
                    .foregroundColor(Color.white)
                    .font(Font.footnote)
            }
            
            VStack(alignment: .leading) {
                Text(accountListItem.nameAccount ?? "not name")
                    .bold()
                Text("Баланс: \(accountListItem.balanceAccount)").font(Font.footnote).foregroundColor(Color.gray)
            }
            
        }
        .contextMenu {
            Button {
                accountListVM.isFavorite(account: accountListItem, context: viewContext)
            } label: {
                Label("Favorite", systemImage: accountListItem.isFavorite ? "heart.slash" : "heart")
            }
            Button {
                accountListVM.accountListTitle = accountListItem.nameAccount!
                accountListVM.accountListItem = accountListItem
                self.isEdit.toggle()
            } label: {
                Label("Edit", systemImage: "highlighter")
            }
            
            Button {
                accountListVM.isArchive(account: accountListItem, context: viewContext)
            } label: {
                Label("Archive", systemImage: accountListItem.isArchive ? "archivebox.fill" : "archivebox")
            }
            Divider()
            Button(role: .destructive) {
                accountListVM.delete(account: accountListItem, context: viewContext)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .sheet(isPresented: $isEdit) {
            NewAccountView(showAdd: $isEdit)
        }
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            Button {
                accountListVM.isFavorite(account: accountListItem, context: viewContext)
            } label: {
                Label("Favorite", systemImage: accountListItem.isFavorite ? "heart.slash" : "heart")
            }.tint(.green)
            
            Button {
                accountListVM.isArchive(account: accountListItem, context: viewContext)
            } label: {
                Label("Archive", systemImage: accountListItem.isArchive ? "archivebox.fill" : "archivebox")
            }.tint(.gray)
            
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
                accountListVM.delete(account: accountListItem, context: viewContext)
            } label: {
                Label("Delete", systemImage: "trash")
            }
            
            Button {
                accountListVM.accountListTitle = accountListItem.nameAccount!
                accountListVM.accountListItem = accountListItem
                self.isEdit.toggle()
            } label: {
                Label("Edit", systemImage: "pencil")
            }.tint(.yellow)
            
        }
        
    }
}

struct AccountCallView_Previews: PreviewProvider {
    static var previews: some View {
        AccountCallView(accountListItem: AccountEntity())
        
    }
}
