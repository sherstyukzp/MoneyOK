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
    @EnvironmentObject var accountListVM: AccountViewModel
    
    @FetchRequest(entity: AccountEntity.entity(), sortDescriptors: [NSSortDescriptor(key: "dateOfCreation", ascending: true)])
    var fetchedAccountList: FetchedResults<AccountEntity>
    
    @State private var addAccountView = false
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    
    var body: some View {
        
        List {
            if !(fetchedAccountList.filter{$0.isFavorite == true}).isEmpty {
                Section("Favorite") {
                    ForEach(fetchedAccountList.filter{$0.isFavorite == true && $0.isArchive == false}) { item in
                        AccountCallView(accountListItem: item)
                    }
                }
            }
            
            Section("Accounts") {
                ForEach(fetchedAccountList.filter{$0.isFavorite == false && $0.isArchive == false}) { item in
                    AccountCallView(accountListItem: item)
                }
            }
            if !(fetchedAccountList.filter{$0.isArchive == true}).isEmpty {
                Section("Archive") {
                    ForEach(fetchedAccountList.filter{$0.isArchive == true}) { item in
                        AccountCallView(accountListItem: item)
                    }
                }
            }
            
            
        }.sheet(isPresented: $addAccountView) {
            NewAccountView(showAdd: $addAccountView)
        }
        
    }
    
    
}




struct AccountsListView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsListView()
    }
}
