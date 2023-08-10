//
//  Navigation.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 10/08/2023.
//

import SwiftUI

struct Navigation: View {
    
#if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
#endif
    

    
    var body: some View {
#if os(iOS)
        if horizontalSizeClass == .compact {
            MainScreen()
        } else {
            SideBarNavigation()
        }
#else
        SideBarNavigation()
#endif
    }
}

struct Navigation_Previews: PreviewProvider {
    static var previews: some View {
        Navigation()
    }
}
