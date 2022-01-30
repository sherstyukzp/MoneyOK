//
//  MoneyOK_iOSApp.swift
//  MoneyOK-iOS
//
//  Created by Ярослав Шерстюк on 21.01.2022.
//

import SwiftUI

@main
struct MoneyOK_iOSApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    
    let persistenceController = PersistenceController.shared
    
    @StateObject var accountListViewModel = AccountViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(accountListViewModel)
        }
    }
}
