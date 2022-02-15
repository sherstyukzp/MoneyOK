//
//  TransactionViewModel.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 09.02.2022.
//

import Foundation
import CoreData

class TransactionViewModel: ObservableObject {
    
    @Published var sumTransactionSave: Double = 0.0
    @Published var noteTransactionSave: String = ""
    @Published var dateTransactionSave: Date = Date()
    
    @Published var transactionItem: TransactionEntity!
    
    
    func createTransaction(context: NSManagedObjectContext, selectedAccount: AccountEntity, selectedCategory: CategoryEntity, typeTransactionNew: TypeTransactionNew) {
        
        if transactionItem == nil {
            let transaction = TransactionEntity(context: context)
            
            var sumSave = 0.0
            if typeTransactionNew == .costs {
                sumSave = sumTransactionSave * -1
            }
            if typeTransactionNew == .income {
                sumSave = sumTransactionSave
            }
            if typeTransactionNew == .transfer {
                // TODO: Добавить алгоритм перевода
                sumSave = sumTransactionSave
            }
            
            transaction.idTransaction = UUID()
            transaction.sumTransaction = sumSave
            transaction.noteTransaction = noteTransactionSave
            transaction.dateTransaction = dateTransactionSave
            transaction.transactionToAccount = selectedAccount
            transaction.transactionToCategory = selectedCategory
            
        } else {
            transactionItem.sumTransaction = sumTransactionSave
            transactionItem.noteTransaction = noteTransactionSave
            transactionItem.dateTransaction = dateTransactionSave
            transactionItem.transactionToAccount = selectedAccount
            transactionItem.transactionToCategory = selectedCategory
        }
        
        save(context: context)
        sumTransactionSave = 0.0
        noteTransactionSave = ""
    }
    
    
    func delete(transaction: TransactionEntity, context: NSManagedObjectContext){
        context.delete(transaction)
        save(context: context)
    }
    
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("🆘 Ошибка сохранения Транзакции \(error.localizedDescription)")
        }
    }
    
    
}
