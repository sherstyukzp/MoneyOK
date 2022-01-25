//
//  SideBarContent.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 21.01.2022.
//

import SwiftUI

struct SideBarContent: View {
    
    @State var isProfileExpanded = true
    
    var body: some View {
        // Это будет главный экран
        
        AccountsListView()
            .listStyle(SidebarListStyle())
            
            
        
        
        
        
        
    }
}

struct SideBarContent_Previews: PreviewProvider {
    static var previews: some View {
        SideBarContent()
    }
}
