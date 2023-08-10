//
//  AccountEntity+CoreDataProperties.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 15.02.2022.
//
//

import Foundation
import CoreData


extension AccountEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AccountEntity> {
        return NSFetchRequest<AccountEntity>(entityName: "AccountEntity")
    }

    @NSManaged public var idAccount: UUID?
    @NSManaged public var nameAccount: String?
    @NSManaged public var colorAccount: String?
    @NSManaged public var dateOfCreation: Date?
    @NSManaged public var iconAccount: String?
    @NSManaged public var isArchive: Bool
    @NSManaged public var isFavorite: Bool
    @NSManaged public var noteAccount: String?
    @NSManaged public var currency: String?
    @NSManaged public var accountToTransaction: Set<TransactionEntity>?
    
    public var transaction: [TransactionEntity] {
            let setOfTransaction = accountToTransaction ?? []
        return setOfTransaction.sorted {
                $0.id > $1.id
            }
    }

}

// MARK: Generated accessors for accountToTransaction
extension AccountEntity {

    @objc(addAccountToTransactionObject:)
    @NSManaged public func addToAccountToTransaction(_ value: TransactionEntity)

    @objc(removeAccountToTransactionObject:)
    @NSManaged public func removeFromAccountToTransaction(_ value: TransactionEntity)

    @objc(addAccountToTransaction:)
    @NSManaged public func addToAccountToTransaction(_ values: NSSet)

    @objc(removeAccountToTransaction:)
    @NSManaged public func removeFromAccountToTransaction(_ values: NSSet)

}

extension AccountEntity : Identifiable {

}
