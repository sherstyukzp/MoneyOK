//
//  TransactionEntity+CoreDataProperties.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 15.02.2022.
//
//

import Foundation
import CoreData


extension TransactionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransactionEntity> {
        return NSFetchRequest<TransactionEntity>(entityName: "TransactionEntity")
    }

    @NSManaged public var idTransaction: UUID?
    @NSManaged public var sumTransaction: Double
    @NSManaged public var dateTransaction: Date?
    @NSManaged public var imageTransaction: Data?
    @NSManaged public var noteTransaction: String?
    @NSManaged public var transactionToAccount: AccountEntity?
    @NSManaged public var transactionToCategory: CategoryEntity?

}

extension TransactionEntity : Identifiable {

}
