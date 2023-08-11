//
//  TransactionViewModel.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 09.02.2022.
//

import Foundation
import CoreData
import UIKit

class TransactionViewModel: ObservableObject {
    
    private let viewContext = PersistenceController.shared.viewContext
    
    @Published var sumTransactionSave: Double = 0.0
    @Published var noteTransactionSave: String = ""
    @Published var dateTransactionSave: Date = Date()
    @Published var imageTransactionSave: UIImage = UIImage()
    @Published var typeTransaction: TypeTrancaction = .expenses
    
    @Published var transactionItem: TransactionEntity!
    
    
    func createTransaction(selectedAccount: AccountEntity, selectedCategory: CategoryEntity) {
        
        if transactionItem == nil {
            let transaction = TransactionEntity(context: viewContext)
            
            if typeTransaction == .expenses {
                sumTransactionSave = sumTransactionSave * -1
            }
            
//            if typeTransactionNew == .transfer {
//                // TODO: Добавить алгоритм перевода
//                sumSave = sumTransactionSave
//            }
            
            transaction.idTransaction = UUID()
            transaction.sumTransaction = sumTransactionSave
            transaction.noteTransaction = noteTransactionSave
            transaction.dateTransaction = dateTransactionSave
            transaction.imageTransaction = imageTransactionSave.pngData()
            transaction.transactionToAccount = selectedAccount
            transaction.transactionToCategory = selectedCategory
            
        } else {
            transactionItem.sumTransaction = sumTransactionSave
            transactionItem.noteTransaction = noteTransactionSave
            transactionItem.dateTransaction = dateTransactionSave
            transactionItem.imageTransaction = imageTransactionSave.pngData()
            transactionItem.transactionToAccount = selectedAccount
            transactionItem.transactionToCategory = selectedCategory
        }
        
        save()
        cleane()
    }
    
    
    func delete(transaction: TransactionEntity){
        viewContext.delete(transaction)
        save()
        cleane()
    }
    
    
    func save() {
        do {
            try viewContext.save()
        } catch {
            print("🆘 Ошибка сохранения Транзакции \(error.localizedDescription)")
        }
    }
    
    func cleane() {
        sumTransactionSave = 0.0
        noteTransactionSave = ""
        transactionItem = nil
    }
    
}
