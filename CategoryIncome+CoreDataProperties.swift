//
//  CategoryIncome+CoreDataProperties.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 30.01.2022.
//
//

import Foundation
import CoreData


extension CategoryIncome {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryIncome> {
        return NSFetchRequest<CategoryIncome>(entityName: "CategoryIncome")
    }

    @NSManaged public var colorCategory: String?
    @NSManaged public var iconCategory: String?
    @NSManaged public var idCategoryIncome: UUID?
    @NSManaged public var nameCategory: String?
    @NSManaged public var transactionIncome: NSSet?

}

// MARK: Generated accessors for transactionIncome
extension CategoryIncome {

    @objc(addTransactionIncomeObject:)
    @NSManaged public func addToTransactionIncome(_ value: Transaction)

    @objc(removeTransactionIncomeObject:)
    @NSManaged public func removeFromTransactionIncome(_ value: Transaction)

    @objc(addTransactionIncome:)
    @NSManaged public func addToTransactionIncome(_ values: NSSet)

    @objc(removeTransactionIncome:)
    @NSManaged public func removeFromTransactionIncome(_ values: NSSet)

}

extension CategoryIncome : Identifiable {

}
