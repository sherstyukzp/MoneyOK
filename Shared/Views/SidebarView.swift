//
//  SidebarView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 21.01.2022.
//

import SwiftUI

struct SidebarView: View {
    
    @State private var showingNewAccount = false
    
    var body: some View {
        
        #if os(iOS)
        SideBarContent()
            .toolbar {
                // Кнопка Настройки
                ToolbarItem(placement: .navigation) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape")
                    }
                }
//                // Кнопки внизу
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button(action: {}, label: {
                            Image(systemName: "plus.circle.fill")
                            Text("Транзакция")
                        })
                        Spacer()
                        Button(action: {
                            self.showingNewAccount.toggle()
                        }, label: {
                            Text("Доб. счёт")
                        })
                    }
                }
            }
            .sheet(isPresented: $showingNewAccount) {
                        NewAccountView()
                    }
        
            .navigationTitle("MoneyOK")
        #else
        SideBarContent()
            .toolbar {
                ToolbarItemGroup {
                    Button(action: toggleSidebar, label: {
                        Image(systemName: "sidebar.left")
                    })
                    
                    Menu {
                        Button("Новая транзакция", action: {})
                        Button("Новый счёт", action: {})
                    } label: {
                        Label("New", systemImage: "plus")
                    }
                        
                    }

            }
        #endif
        }
    
    func toggleSidebar() {
        #if os(macOS)
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
        #endif
    }
    
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView()
    }
}
