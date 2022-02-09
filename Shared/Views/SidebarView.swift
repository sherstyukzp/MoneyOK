//
//  SidebarView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 21.01.2022.
//

import SwiftUI

struct SidebarView: View {
    
    var body: some View {
        
#if os(iOS)
        // если устройство iPhone
        AccountsListView()
            .listStyle(SidebarListStyle())
        
            
#else
        // Есле устройство Mac & iPad
        AccountsListView()
            .listStyle(SidebarListStyle())
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
