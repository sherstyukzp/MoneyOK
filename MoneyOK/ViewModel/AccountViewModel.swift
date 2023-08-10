//
//  AccountViewModel.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 09.02.2022.
//

import Foundation
import CoreData


class AccountViewModel: ObservableObject {
    
    @Published var accountSelect: AccountEntity!
    
    @Published var nameAccount = ""
    @Published var iconAccount = "creditcard.fill"
    @Published var colorAccount = "swatch_articblue"
    @Published var noteAccount = ""
    @Published var selectedCurrency: Currency = .usd
    @Published var dateOfCreationSave = Date()
    
    func createAccount(context: NSManagedObjectContext) {
        
        if accountSelect == nil {
            let account = AccountEntity(context: context)
            account.idAccount = UUID()
            account.nameAccount = nameAccount
            account.iconAccount = iconAccount
            account.colorAccount = colorAccount
            account.noteAccount = noteAccount
            account.currency = selectedCurrency.rawValue
            account.dateOfCreation = Date()
        } else {
            accountSelect.nameAccount = nameAccount
            accountSelect.iconAccount = iconAccount
            accountSelect.colorAccount = colorAccount
            accountSelect.noteAccount = noteAccount
            accountSelect.currency = selectedCurrency.rawValue
            accountSelect.dateOfCreation = dateOfCreationSave
        }
        
        save(context: context)
        clean()
    }
    
    func isFavorite(account: AccountEntity, context: NSManagedObjectContext) {
        account.isFavorite.toggle()
        save(context: context)
    }
    
    func isArchive(account: AccountEntity, context: NSManagedObjectContext) {
        account.isArchive.toggle()
        save(context: context)
    }
    
    func editAccount(account: AccountEntity){
        accountSelect = account
    }
    
    func delete(account: AccountEntity, context: NSManagedObjectContext){
        context.delete(account)
        save(context: context)
    }
    
    private func clean() {
        nameAccount = ""
        iconAccount = ""
        colorAccount = ""
        noteAccount = ""
        selectedCurrency = .usd
        accountSelect = nil
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("🆘 Ошибка сохранения Счёта \(error.localizedDescription)")
        }
    }
    
    
}
