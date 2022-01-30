//
//  CategoryCosts+CoreDataProperties.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 30.01.2022.
//
//

import Foundation
import CoreData


extension CategoryCosts {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryCosts> {
        return NSFetchRequest<CategoryCosts>(entityName: "CategoryCosts")
    }

    @NSManaged public var colorCategory: String?
    @NSManaged public var iconCategory: String?
    @NSManaged public var idCategoryCosts: UUID?
    @NSManaged public var nameCategory: String?
    @NSManaged public var transactionsCosts: NSSet?

}

// MARK: Generated accessors for transactionsCosts
extension CategoryCosts {

    @objc(addTransactionsCostsObject:)
    @NSManaged public func addToTransactionsCosts(_ value: Transaction)

    @objc(removeTransactionsCostsObject:)
    @NSManaged public func removeFromTransactionsCosts(_ value: Transaction)

    @objc(addTransactionsCosts:)
    @NSManaged public func addToTransactionsCosts(_ values: NSSet)

    @objc(removeTransactionsCosts:)
    @NSManaged public func removeFromTransactionsCosts(_ values: NSSet)

}

extension CategoryCosts : Identifiable {

}
