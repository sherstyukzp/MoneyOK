//
//  MoneyOKApp.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 09.02.2022.
//

import SwiftUI

@main
struct MoneyOKApp: App {
    let persistenceController = PersistenceController.shared
    
    @StateObject var accountViewModel = AccountViewModel()
    @StateObject var transactionViewModel = TransactionViewModel()
    @StateObject var categoryViewModel = CategoryViewModel()
    
    var body: some Scene {
        WindowGroup {
            AccountsView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(accountViewModel)
                .environmentObject(transactionViewModel)
                .environmentObject(categoryViewModel)
        }
    }
}
