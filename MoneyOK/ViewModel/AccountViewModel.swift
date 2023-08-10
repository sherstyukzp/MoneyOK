//
//  AccountViewModel.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 09.02.2022.
//

import Foundation
import CoreData


class AccountViewModel: ObservableObject {
    
    private let viewContext = PersistenceController.shared.viewContext
    
    @Published var accountSelect: AccountEntity!
    
    @Published var nameAccount = ""
    @Published var iconAccount = "creditcard.fill"
    @Published var colorAccount = "swatch_articblue"
    @Published var noteAccount = ""
    @Published var selectedCurrency: Currency = .usd
    @Published var dateOfCreationSave = Date()
    
    func createAccount() {
        
        if accountSelect == nil {
            let account = AccountEntity(context: viewContext)
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
        
        save()
        clean()
    }
    
    func isFavorite(account: AccountEntity) {
        account.isFavorite.toggle()
        save()
        clean()
    }
    
    func isArchive(account: AccountEntity) {
        account.isArchive.toggle()
        save()
        clean()
    }
    
    func editAccount(account: AccountEntity){
        accountSelect = account
        clean()
    }
    
    func delete(account: AccountEntity){
        viewContext.delete(account)
        save()
        clean()
    }
    
    func clean() {
        nameAccount = ""
        iconAccount = ""
        colorAccount = ""
        noteAccount = ""
        selectedCurrency = .usd
        accountSelect = nil
    }
    
    func save() {
        do {
            try viewContext.save()
        } catch {
            print("🆘 Ошибка сохранения Счёта \(error.localizedDescription)")
        }
    }
    
    
}
