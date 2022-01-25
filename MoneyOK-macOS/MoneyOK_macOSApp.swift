//
//  MoneyOK_macOSApp.swift
//  MoneyOK-macOS
//
//  Created by Ярослав Шерстюк on 21.01.2022.
//

import SwiftUI

@main
struct MoneyOK_macOSApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.commands {
            SidebarCommands() // Добавляет в меню скрытие/отображение Sidebar
        }
        // Добавляет в меню пункт Настройки
        #if os(macOS)
        Settings {
            SettingsView()
        }
        #endif
    }
}
