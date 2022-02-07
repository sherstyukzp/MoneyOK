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
    @StateObject var transactionListViewModel = TransactionViewModel()
    //@StateObject var categoryListViewModel = CategoryCostsViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(accountListViewModel)
                .environmentObject(transactionListViewModel)
                //.environmentObject(categoryListViewModel)
        }
    }
}
