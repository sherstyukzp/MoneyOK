//
//  AccountsListShowView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 02.02.2022.
//

import SwiftUI
import CoreData

struct AccountsListShowView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    
    @FetchRequest(entity: AccountEntity.entity(), sortDescriptors: [NSSortDescriptor(key: "dateOfCreation", ascending: true)])
    var accountList: FetchedResults<AccountEntity>
    
    var body: some View {
        
        List {
            ForEach(accountList) { item in
                AccountCallView(accountListItem: item)
            }
        }
        .navigationTitle("Счета")
        
    }
}

struct AccountsListShowView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsListShowView()
    }
}
