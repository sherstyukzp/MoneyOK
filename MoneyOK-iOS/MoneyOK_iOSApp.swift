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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.viewContext)
        }.onChange(of: scenePhase) { _ in
            persistenceController.saveContext()
        }
    }
}
