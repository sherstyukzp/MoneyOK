//
//  CategoryEntity+CoreDataProperties.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 06.02.2022.
//
//

import Foundation
import CoreData


extension CategoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryEntity> {
        return NSFetchRequest<CategoryEntity>(entityName: "CategoryEntity")
    }

    @NSManaged public var colorCategory: String?
    @NSManaged public var iconCategory: String?
    @NSManaged public var idCategory: UUID?
    @NSManaged public var nameCategory: String?
    @NSManaged public var isExpenses: Bool
    @NSManaged public var categoryToTransaction: TransactionEntity?

}

extension CategoryEntity : Identifiable {

}
