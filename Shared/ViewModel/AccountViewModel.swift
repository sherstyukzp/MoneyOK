//
//  AccountViewModel.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 30.01.2022.
//

import Foundation
import CoreData

class AccountViewModel: ObservableObject {
    
    @Published var accountListTitle = ""
    // тут ещё данные аккаунта
    @Published var accountListItem: AccountEntity!
    
    func createTask(context: NSManagedObjectContext) {
        
        if accountListItem == nil {
            let account = AccountEntity(context: context)
            account.idAccount = UUID()
            account.nameAccount = accountListTitle
            account.dateOfCreation = Date()
            // TODO: Добавить остальные данные
        } else {
            accountListItem.nameAccount = accountListTitle
        }
        
        save(context: context)
        accountListTitle = ""
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
