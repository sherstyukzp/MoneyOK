//
//  CategoryCostsViewModel.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 05.02.2022.
//

import Foundation
import CoreData

class CategoryCostsViewModel: ObservableObject {
    
    @Published var nameCategoryCostsSave = ""
    @Published var iconCategoryCostsSave = "creditcard.fill"
    @Published var colorCategoryCostsSave = "swatch_articblue"


    @Published var categoryListItem: CategoryEntity!
    
    func createCategoryCosts(context: NSManagedObjectContext) {
        
        if categoryListItem == nil {
            let account = CategoryEntity(context: context)
            account.idCategory = UUID()
            account.nameCategory = nameCategoryCostsSave
            account.iconCategory = iconCategoryCostsSave
            account.colorCategory = colorCategoryCostsSave
            
        } else {
            categoryListItem.nameCategory = nameCategoryCostsSave
            categoryListItem.iconCategory = iconCategoryCostsSave
            categoryListItem.colorCategory = colorCategoryCostsSave
        }
        
        save(context: context)
        nameCategoryCostsSave = ""
        iconCategoryCostsSave = ""
        colorCategoryCostsSave = ""
        
    }
    
    
    func editList(category: CategoryEntity){
        categoryListItem = category
    }
    
    func delete(category: CategoryEntity, context: NSManagedObjectContext) {
        context.delete(category)
        save(context: context)
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
}

