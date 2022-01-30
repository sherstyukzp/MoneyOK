//
//  AccountViewModel.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 30.01.2022.
//

import Foundation
import CoreData

class AccountViewModel: ObservableObject {
    
    @Published var nameAccountSave = ""
    @Published var iconAccountSave = ""
    @Published var colorAccountSave = ""
    @Published var noteAccountSave = ""
    @Published var balanceAccountSave = 0.0

    @Published var accountListItem: AccountEntity!
    
    func createTask(context: NSManagedObjectContext) {
        
        if accountListItem == nil {
            let account = AccountEntity(context: context)
            account.idAccount = UUID()
            account.nameAccount = nameAccountSave
            account.iconAccount = iconAccountSave
            account.colorAccount = colorAccountSave
            account.noteAccount = noteAccountSave
            account.balanceAccount = balanceAccountSave
            account.dateOfCreation = Date()
            
        } else {
            accountListItem.nameAccount = nameAccountSave
            accountListItem.iconAccount = iconAccountSave
            accountListItem.colorAccount = colorAccountSave
            accountListItem.noteAccount = noteAccountSave
            accountListItem.balanceAccount = balanceAccountSave
        }
        
        save(context: context)
        nameAccountSave = ""
        iconAccountSave = ""
        colorAccountSave = ""
        noteAccountSave = ""
        balanceAccountSave = 0.0
        
    }
    
    
    func isFavorite(account: AccountEntity, context: NSManagedObjectContext) {
        account.isFavorite.toggle()
        save(context: context)
    }
    
    func isArchive(account: AccountEntity, context: NSManagedObjectContext) {
        account.isArchive.toggle()
        save(context: context)
    }
    
    func editList(account: AccountEntity){
        accountListItem = account
    }
    
    func delete(account: AccountEntity, context: NSManagedObjectContext) {
        context.delete(account)
        save(context: context)
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
}
