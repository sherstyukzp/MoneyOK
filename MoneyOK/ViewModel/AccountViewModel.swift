//
//  AccountViewModel.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 09.02.2022.
//

import Foundation
import CoreData


class AccountViewModel: ObservableObject {
    
    @Published var nameAccountSave = ""
    @Published var iconAccountSave = "creditcard.fill"
    @Published var colorAccountSave = "swatch_articblue"
    @Published var noteAccountSave = ""
    @Published var dateOfCreationSave = Date()
    
    @Published var accountItem: AccountEntity!
    
    
    func createAccount(context: NSManagedObjectContext) {
        
        if accountItem == nil {
            let account = AccountEntity(context: context)
            account.idAccount = UUID()
            account.nameAccount = nameAccountSave
            account.iconAccount = iconAccountSave
            account.colorAccount = colorAccountSave
            account.noteAccount = noteAccountSave
            account.dateOfCreation = Date()
            
            
        } else {
            accountItem.nameAccount = nameAccountSave
            accountItem.iconAccount = iconAccountSave
            accountItem.colorAccount = colorAccountSave
            accountItem.noteAccount = noteAccountSave
            
        }
        
        save(context: context)
        nameAccountSave = ""
        iconAccountSave = ""
        colorAccountSave = ""
        noteAccountSave = ""
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
        accountItem = account
    }
    
    func delete(account: AccountEntity, context: NSManagedObjectContext){
        context.delete(account)
        save(context: context)
    }
    
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("🆘 Ошибка сохранения Счёта \(error.localizedDescription)")
        }
    }
    
    
}
