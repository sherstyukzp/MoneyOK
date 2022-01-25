//
//  SettingsView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 21.01.2022.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        List {
            Text("Настройка 1")
            Text("Настройка 2")
            Text("Настройка 3")
        }
        
            .navigationTitle("Settings")
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
