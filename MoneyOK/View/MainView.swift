//
//  MainView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 15.02.2023.
//

import SwiftUI

struct MainView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.nameAccount, order: .forward)])
    private var fetchedAccount: FetchedResults<AccountEntity>
    
    var body: some View {
        if fetchedAccount.isEmpty {
            NavigationStack {
                NotAccountsView()
            }
        }
        else {
            AccountsListView()
        }
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
