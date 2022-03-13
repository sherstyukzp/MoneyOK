//
//  SettingsView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 09.02.2022.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        Form {
//            NavigationLink("Acoount") {
//                AccountsListView().navigationTitle("Accounts")
//            }
            NavigationLink("Category") {
                CategotyView()
            }
            NavigationLink("Transactions") {
                TransactionAllListView()
            }
        }
        
        .navigationTitle("Settings")
        
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
