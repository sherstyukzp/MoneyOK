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
            NavigationLink("Счета") {
                AccountsListView().navigationTitle("Счета")
            }
            NavigationLink("Категории") {
                CategotyView()
            }
            NavigationLink("Транзакции") {
                TransactionAllListView()
            }
        }
        
        .navigationTitle("Настройки")
        
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
