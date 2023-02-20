//
//  AccountViewModel.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 09.02.2022.
//

import Foundation
import CoreData


class AccountViewModel: ObservableObject {
    
    @Published var accountModel = AccountModel()
    
    @Published var accountSelect: AccountEntity!
    
    
    func createAccount(context: NSManagedObjectContext) {
        
        if accountSelect == nil {
            let account = AccountEntity(context: context)
            account.idAccount = UUID()
            account.nameAccount = accountModel.nameAccount
            account.iconAccount = accountModel.iconAccount
            account.colorAccount = accountModel.colorAccount
            account.noteAccount = accountModel.noteAccount
            account.dateOfCreation = Date()
        } else {
            accountSelect.nameAccount = accountModel.nameAccount
            accountSelect.iconAccount = accountModel.iconAccount
            accountSelect.colorAccount = accountModel.colorAccount
            accountSelect.noteAccount = accountModel.noteAccount
            accountSelect.dateOfCreation = Date()
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
    
    func clean() {
        accountModel.nameAccount = ""
        accountModel.iconAccount = ""
        accountModel.colorAccount = ""
        accountModel.noteAccount = ""
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
