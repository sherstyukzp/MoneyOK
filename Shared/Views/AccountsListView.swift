//
//  AccountsListView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 21.01.2022.
//

import SwiftUI

struct AccountsListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: Account.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Account.nameAccount, ascending: true)],
        animation: .default)
    private var accounts: FetchedResults<Account>
    
    @State private var showingUpdateAccount = false
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    var body: some View {
        
        List {
            Section(header: Text("Accounts")) {
                ForEach(self.accounts, id:\.self) { (account: Account) in
                    NavigationLink(destination: TransactionListView(account: account).environment(\.managedObjectContext, self.viewContext)) {
                        
                        AccountView(colorAccount: account.colorAccount!, iconAccount: account.iconAccount!, nameAccount: account.nameAccount! , balance: account.balanceAccount)
                    }
                    .contextMenu {
                        Button {
                            self.showingUpdateAccount.toggle()
                        } label: {
                            Label("Edit", systemImage: "highlighter")
                        }
                        Button {
                            
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .sheet(isPresented: $showingUpdateAccount) {
                        UpdateAccountView(account: account).environment(\.managedObjectContext, self.viewContext)
                    }
                    
                }.onDelete(perform: deleteAccount)
                
            }
        }
    }
    
    
    
    private func deleteAccount(offsets: IndexSet) {
        withAnimation {
            offsets.map { accounts[$0] }.forEach(viewContext.delete)
            PersistenceController.shared.saveContext()
        }
    }
}




struct AccountsListView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsListView()
    }
}
