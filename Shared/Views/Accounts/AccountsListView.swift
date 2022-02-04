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
    
    @FetchRequest(entity: AccountEntity.entity(), sortDescriptors: [NSSortDescriptor(key: "dateOfCreation", ascending: true)])
    var fetchedAccountList: FetchedResults<AccountEntity>
    
    
    @ObservedObject var accountListItem: AccountEntity
    
    @State private var isEdit = false
    
    var body: some View {
        
        List {
            if !(fetchedAccountList.filter{$0.isFavorite == true}).isEmpty {
                Section("Избранные") {
                    ForEach(fetchedAccountList.filter{$0.isFavorite == true && $0.isArchive == false}) { (item: AccountEntity) in
                        NavigationLink(destination:
                                        TransactionListView(accountListItem: item).environment(\.managedObjectContext, self.viewContext))
                        {
                            AccountCallView(accountListItem: item)
                        }
                        
                        .swipeActions() {
                            }
                    }
                }
            }
            
            Section(fetchedAccountList.count <= 1 ? "Счёт" : "Счета") {
                ForEach(fetchedAccountList.filter{$0.isFavorite == false && $0.isArchive == false}) { (item: AccountEntity) in
                    NavigationLink(destination:
                                    TransactionListView(accountListItem: item).environment(\.managedObjectContext, self.viewContext))
                    {
                        AccountCallView(accountListItem: item)
                    }
                    
                    .swipeActions() {
                        }
                }
            }
            if !(fetchedAccountList.filter{$0.isArchive == true}).isEmpty {
                Section("Архив") {
                    ForEach(fetchedAccountList.filter{$0.isArchive == true}) { (item: AccountEntity) in
                        NavigationLink(destination:
                                        TransactionListView(accountListItem: item).environment(\.managedObjectContext, self.viewContext))
                        {
                            AccountCallView(accountListItem: item)
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
