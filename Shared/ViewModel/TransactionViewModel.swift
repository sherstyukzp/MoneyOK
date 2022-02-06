//
//  TransactionViewModel.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 03.02.2022.
//

import Foundation
import CoreData

class TransactionViewModel: ObservableObject {
    
    @Published var noteTransactionSave = ""
    @Published var sumTransactionSave = 0.0
    
    // TODO: Добавить фото, категорию
    @Published var transactionListItem: TransactionEntity!
    @Published var accountListItem: AccountEntity!
    
    func createTransaction(context: NSManagedObjectContext, selectAccount: AccountEntity) {
        
        if accountListItem == nil {
            let transaction = TransactionEntity(context: context)
            transaction.idTransaction = UUID()
            transaction.sumTransaction = sumTransactionSave
            transaction.dateTransaction = Date()
            
        } else {
            transactionListItem.sumTransaction = sumTransactionSave
            
            transactionListItem.transactionsToAccounts = selectAccount
            
        }
        
        save(context: context)
        sumTransactionSave = 0.0
        
    }
    
    
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
}
