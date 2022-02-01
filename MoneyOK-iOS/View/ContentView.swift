//
//  ContentView.swift
//  MoneyOK-iOS
//
//  Created by Ярослав Шерстюк on 21.01.2022.
//

import SwiftUI

struct ContentView: View {
    
    
    
    var body: some View {
        NavigationView {
            VStack {
                SidebarView()
                .safeAreaInset(edge: .bottom) {
                        PanelView()
                        }
            }
            .toolbar {
                    // Кнопка Настройки
                    ToolbarItem(placement: .navigation) {
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gearshape")
                        }
                    }
            }
                
            
                .navigationTitle("MoneyOK")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
