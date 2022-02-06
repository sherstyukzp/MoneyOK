//
//  AccountEntity+CoreDataProperties.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 06.02.2022.
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
    @NSManaged public var isArchive: Bool
    @NSManaged public var isFavorite: Bool
    @NSManaged public var nameAccount: String?
    @NSManaged public var noteAccount: String?
    @NSManaged public var orderIndex: Int64
    @NSManaged public var accountsToTransactions: Set<TransactionEntity>?
    
    public var transaction: [TransactionEntity]{
            let setOfTransaction = accountsToTransactions
            return setOfTransaction!.sorted {
                $0.id > $1.id
            }
    }

}

// MARK: Generated accessors for accountsToTransactions
extension AccountEntity {

    @objc(addAccountsToTransactionsObject:)
    @NSManaged public func addToAccountsToTransactions(_ value: TransactionEntity)

    @objc(removeAccountsToTransactionsObject:)
    @NSManaged public func removeFromAccountsToTransactions(_ value: TransactionEntity)

    @objc(addAccountsToTransactions:)
    @NSManaged public func addToAccountsToTransactions(_ values: NSSet)

    @objc(removeAccountsToTransactions:)
    @NSManaged public func removeFromAccountsToTransactions(_ values: NSSet)

}

extension AccountEntity : Identifiable {

}
