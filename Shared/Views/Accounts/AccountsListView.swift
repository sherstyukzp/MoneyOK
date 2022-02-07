//
//  AccountsListView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 21.01.2022.
//

import SwiftUI
import CoreData

struct AccountsListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: AccountEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \AccountEntity.dateOfCreation, ascending: true)])
    var fetchAccounts: FetchedResults<AccountEntity>
    
    
    @ObservedObject var accountListItem: AccountEntity
    
    //@ObservedObject var categoryListItem: CategoryEntity
    
    @State private var isEdit = false
    
    var body: some View {
        
        List {
            if !(fetchAccounts.filter{$0.isFavorite == true}).isEmpty {
                Section("Избранные") {
                    ForEach(fetchAccounts.filter{$0.isFavorite == true && $0.isArchive == false}) { (account: AccountEntity) in
                        NavigationLink(destination:
                                        TransactionListView(accountListItem: account).environment(\.managedObjectContext, self.viewContext))
                        {
                            AccountCallView(accountListItem: account)
                        }
                        
                        .swipeActions() {
                            }
                    }
                }
            }
            
            Section(fetchAccounts.count <= 1 ? "Счёт" : "Счета") {
                ForEach(fetchAccounts.filter{$0.isFavorite == false && $0.isArchive == false}) { (account: AccountEntity) in
                    NavigationLink(destination:
                                    TransactionListView(accountListItem: account).environment(\.managedObjectContext, self.viewContext))
                    {
                        AccountCallView(accountListItem: account)
                    }
                    
                    .swipeActions() {
                        }
                }
            }
            if !(fetchAccounts.filter{$0.isArchive == true}).isEmpty {
                Section("Архив") {
                    ForEach(fetchAccounts.filter{$0.isArchive == true}) { (account: AccountEntity) in
                        NavigationLink(destination:
                                        TransactionListView(accountListItem: account).environment(\.managedObjectContext, self.viewContext))
                        {
                            AccountCallView(accountListItem: account)
                        }
                        
                        .swipeActions() {
                            }
                    }
                }
            }

                
        }
        
        
        
    }
    
    
    
    
    
}




struct AccountsListView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsListView(accountListItem: AccountEntity())
    }
}
