//
//  AccountCallView.swift
//  AccountApp
//
//  Created by Ярослав Шерстюк on 09.02.2022.
//

import SwiftUI

struct AccountCallView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var accountVM: AccountViewModel
    @ObservedObject var accountItem: AccountEntity
    
    @State private var isEditAccount = false // Вызов редактирования счёта
    @State private var isNewTransaction = false // Вызов новой транзакции
    
    // Alert
    @State var showAlert: Bool = false
    @State var alertTitle: String = "Удаление счёта"
    @State var alertMessage: String = "Вы действительно хотите удалить счёт?"
    
    // Сумма всех транзакций выбраного счёта
    var sumTransaction: Double {
        accountItem.transaction.reduce(0) { $0 + $1.sumTransaction }
    }
    
    var body: some View {
        
        HStack {
            ZStack {
                Circle()
                    .fill(Color((accountItem.isArchive ? "swatch_gunsmoke" : accountItem.colorAccount) ?? "swatch_gunsmoke"))
                    .frame(width: 32, height: 32)
                Image(systemName: accountItem.iconAccount ?? "plus")
                    .foregroundColor(Color.white)
                    .font(Font.footnote)
            }
            
            VStack(alignment: .leading) {
                Text(accountItem.nameAccount ?? "no name")
                    .bold()
                    .foregroundColor(accountItem.isArchive ? .gray : .primary)
                Text("Баланс: \(sumTransaction, format: .currency(code: "UAH"))")
                    .font(Font.footnote)
                    .foregroundColor(Color.gray)
            }
        }
        .contextMenu {
            // Вызов новой транзакции через кантексное меню счёта
            Button {
                self.isNewTransaction.toggle()
            } label: {
                Label("Новая транзакция", systemImage: "plus.circle")
            }
            
            Divider()
            if accountItem.isArchive == false {
                Button {
                    accountVM.isFavorite(account: accountItem, context: viewContext)
                } label: {
                    Label("Избранный", systemImage: accountItem.isFavorite ? "heart.slash" : "heart")
                }
            }
            
            Button {
                accountVM.nameAccountSave = accountItem.nameAccount!
                accountVM.iconAccountSave = accountItem.iconAccount!
                accountVM.colorAccountSave = accountItem.colorAccount!
                accountVM.noteAccountSave = accountItem.noteAccount!
                accountVM.accountItem = accountItem
                self.isEditAccount.toggle()
            } label: {
                Label("Редактировать", systemImage: "highlighter")
            }
            
            Button {
                accountVM.isArchive(account: accountItem, context: viewContext)
                if accountItem.isFavorite == true {
                    accountVM.isFavorite(account: accountItem, context: viewContext)
                }
                
            } label: {
                Label(accountItem.isArchive ? "Разархивировать" : "Архивировать", systemImage: accountItem.isArchive ? "archivebox.fill" : "archivebox")
            }
            Divider()
            Button(role: .destructive) {
                showAlert.toggle()
            } label: {
                Label("Удалить", systemImage: "trash")
            }
        }
        // Свайп влево
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            if accountItem.isArchive == false {
                Button {
                    accountVM.isFavorite(account: accountItem, context: viewContext)
                } label: {
                    Label("Избранный", systemImage: accountItem.isFavorite ? "heart.slash" : "heart")
                }.tint(.green)
            }
            
            
            Button {
                accountVM.isArchive(account: accountItem, context: viewContext)
                if accountItem.isFavorite == true {
                    accountVM.isFavorite(account: accountItem, context: viewContext)
                }
                
            } label: {
                Label("Архивировать", systemImage: accountItem.isArchive ? "archivebox.fill" : "archivebox")
            }.tint(.gray)
            
        }
        // Свайп вправо
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
                showAlert.toggle()
            } label: {
                Label("Удалить", systemImage: "trash")
            }
            
            Button {
                accountVM.nameAccountSave = accountItem.nameAccount!
                accountVM.iconAccountSave = accountItem.iconAccount!
                accountVM.colorAccountSave = accountItem.colorAccount!
                accountVM.noteAccountSave = accountItem.noteAccount!
                accountVM.accountItem = accountItem
                self.isEditAccount.toggle()
            } label: {
                Label("Редактировать", systemImage: "pencil")
            }.tint(.yellow)
            
        }
        
        .sheet(isPresented: $isEditAccount) {
            AccountNewView(isNewAccount: $isEditAccount)
        }
        .sheet(isPresented: $isNewTransaction) {
            TransactionNewView(accountItem: accountItem, isNewTransaction: $isNewTransaction, nowAccount: false)
        }
        .alert(isPresented: $showAlert) {
            getAlert()
        }
        
        
    }
    
    // MARK: Alert
    func getAlert() -> Alert {
        return Alert(title: Text(alertTitle),
                     message: Text(alertMessage),
                     primaryButton: .destructive(Text("Да"),
                                                 action: {
            accountVM.delete(account: accountItem, context: viewContext)
        }),
                     secondaryButton: .cancel())
    }
    
}

struct AccountCallView_Previews: PreviewProvider {
    static var previews: some View {
        AccountCallView(accountItem: AccountEntity())
    }
}
