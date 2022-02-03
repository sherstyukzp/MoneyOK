//
//  TransactionViewModel.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 03.02.2022.
//

import Foundation
import CoreData

class TransactionViewModel: ObservableObject {
    
    @Published var nameTransactionSave = ""
    @Published var noteTransactionSave = ""
    @Published var sumTransactionSave = 0.0
    // TODO: Добавить фото
    @Published var transactionListItem: Transaction!
    
    
    
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
}
