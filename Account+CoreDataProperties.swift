//
//  Account+CoreDataProperties.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 25.01.2022.
//
//

import Foundation
import CoreData


extension Account {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account")
    }

    @NSManaged public var nameAccount: String?
    @NSManaged public var balanceAccount: Double
    @NSManaged public var colorAccount: String?
    @NSManaged public var noteAccount: String?
    @NSManaged public var dateOfCreation: Date?
    @NSManaged public var iconAccount: String?
    @NSManaged public var idAccount: UUID?
    @NSManaged public var transactions: NSSet?

}

// MARK: Generated accessors for transactions
extension Account {

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: Transaction)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: Transaction)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)

}

extension Account : Identifiable {

}
