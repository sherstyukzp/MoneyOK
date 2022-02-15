//
//  CategoryEntity+CoreDataProperties.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 15.02.2022.
//
//

import Foundation
import CoreData


extension CategoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryEntity> {
        return NSFetchRequest<CategoryEntity>(entityName: "CategoryEntity")
    }

    @NSManaged public var idCategory: UUID?
    @NSManaged public var nameCategory: String?
    @NSManaged public var colorCategory: String?
    @NSManaged public var iconCategory: String?
    @NSManaged public var isExpenses: Bool
    @NSManaged public var categoryToTransaction: Set<CategoryEntity>?
    
    public var category: [CategoryEntity] {
            let setOfCategory = categoryToTransaction ?? []
        return setOfCategory.sorted {
                $0.id > $1.id
            }
    }

}

// MARK: Generated accessors for categoryToTransaction
extension CategoryEntity {

    @objc(addCategoryToTransactionObject:)
    @NSManaged public func addToCategoryToTransaction(_ value: TransactionEntity)

    @objc(removeCategoryToTransactionObject:)
    @NSManaged public func removeFromCategoryToTransaction(_ value: TransactionEntity)

    @objc(addCategoryToTransaction:)
    @NSManaged public func addToCategoryToTransaction(_ values: NSSet)

    @objc(removeCategoryToTransaction:)
    @NSManaged public func removeFromCategoryToTransaction(_ values: NSSet)

}

extension CategoryEntity : Identifiable {

}
