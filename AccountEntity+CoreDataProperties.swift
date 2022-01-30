//
//  AccountEntity+CoreDataProperties.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 30.01.2022.
//
//

import Foundation
import CoreData


extension AccountEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AccountEntity> {
        return NSFetchRequest<AccountEntity>(entityName: "AccountEntity")
    }

    @NSManaged public var balanceAccount: Double
    @NSManaged public var colorAccount: String?
    @NSManaged public var dateOfCreation: Date?
    @NSManaged public var iconAccount: String?
    @NSManaged public var idAccount: UUID?
    @NSManaged public var nameAccount: String?
    @NSManaged public var noteAccount: String?
    @NSManaged public var isArchive: Bool
    @NSManaged public var isFavorite: Bool
    @NSManaged public var transactions: NSSet?

}

// MARK: Generated accessors for transactions
extension AccountEntity {

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: Transaction)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: Transaction)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)

}

extension AccountEntity : Identifiable {

}
