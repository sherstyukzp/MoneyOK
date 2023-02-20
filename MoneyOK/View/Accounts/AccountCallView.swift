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
                    .fill(Color((accountItem.isArchive ? "forArhive" : accountItem.colorAccount) ?? "forArhive"))
                    .frame(width: 36, height: 36)
                Image(systemName: accountItem.iconAccount ?? "plus")
                    .foregroundColor(Color.white)
                    .font(Font.footnote)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(accountItem.nameAccount ?? "no name")
                    .foregroundColor(accountItem.isArchive ? .gray : .primary)
                    .font(.headline)
                    .fontWeight(.bold)
                Text("Balance: \(sumTransaction, format: .currency(code: "USD"))")
                    .font(Font.footnote)
                    .foregroundColor(Color.gray)
            }
        }
        .contextMenu {
            // Вызов новой транзакции через кантексное меню счёта
            Button {
                accountVM.accountSelect = accountItem
                self.isNewTransaction.toggle()
            } label: {
                Label("New transaction", systemImage: "plus.circle")
            }
            
            Divider()
            if accountItem.isArchive == false {
                Button {
                    accountVM.isFavorite(account: accountItem, context: viewContext)
                } label: {
                    Label("Favorite", systemImage: accountItem.isFavorite ? "heart.slash" : "heart")
                }
            }
            
            Button {
                accountVM.accountModel.nameAccount = accountItem.nameAccount!
                accountVM.accountModel.iconAccount = accountItem.iconAccount!
                accountVM.accountModel.colorAccount = accountItem.colorAccount!
                accountVM.accountModel.noteAccount = accountItem.noteAccount!
                accountVM.accountSelect = accountItem
                self.isEditAccount.toggle()
            } label: {
                Label("Edit", systemImage: "highlighter")
            }
            
            Button {
                accountVM.isArchive(account: accountItem, context: viewContext)
                if accountItem.isFavorite == true {
                    accountVM.isFavorite(account: accountItem, context: viewContext)
                }
                
            } label: {
                Label(accountItem.isArchive ? "Unarchive" : "Archive", systemImage: accountItem.isArchive ? "archivebox.fill" : "archivebox")
            }
            Divider()
            Button(role: .destructive) {
                showAlert.toggle()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        // Свайп влево
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            Button {
                accountVM.accountSelect = accountItem
                isNewTransaction.toggle()
            } label: {
                Image(systemName: "plus.circle.fill")
            }.tint(.green)

        }
        // Свайп вправо
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button {
                accountVM.accountSelect = accountItem
                isNewTransaction.toggle()
            } label: {
                Image(systemName: "minus.circle.fill")
            }.tint(.red)
        }
        
        .sheet(isPresented: $isEditAccount) {
            AccountNewView()
        }
        .sheet(isPresented: $isNewTransaction) {
            TransactionNewView()
        }
        .alert(isPresented: $showAlert) {
            getAlert()
        }
        
        
    }
    
    // MARK: Alert
    func getAlert() -> Alert {
        return Alert(title: Text(alertTitle),
                     message: Text(alertMessage),
                     primaryButton: .destructive(Text("Yes"),
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
