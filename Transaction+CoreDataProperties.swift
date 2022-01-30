//
//  Transaction+CoreDataProperties.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 30.01.2022.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var idTransaction: UUID?
    @NSManaged public var nameTransaction: String?
    @NSManaged public var noteTransaction: String?
    @NSManaged public var sumTransaction: Double
    @NSManaged public var accounts: AccountEntity?
    @NSManaged public var categoryCosts: CategoryCosts?
    @NSManaged public var categoryIncome: CategoryIncome?

}

extension Transaction : Identifiable {

}
