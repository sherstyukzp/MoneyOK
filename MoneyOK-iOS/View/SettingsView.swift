//
//  SettingsView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 21.01.2022.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        Form {
            NavigationLink(destination: AccountsListView()) {
                Text("Счета")
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
