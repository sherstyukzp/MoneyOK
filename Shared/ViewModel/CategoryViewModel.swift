//
//  CategoryViewModel.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 05.02.2022.
//

import Foundation
import CoreData

class CategoryViewModel: ObservableObject {
    
    @Published var nameCategorySave = ""
    @Published var iconCategorySave = "creditcard.fill"
    @Published var colorCategorySave = "swatch_articblue"


    @Published var categoryListItem: CategoryEntity!
    
    func createCategoryCosts(context: NSManagedObjectContext) {
        
        if categoryListItem == nil {
            let category = CategoryEntity(context: context)
            category.idCategory = UUID()
            category.nameCategory = nameCategorySave
            category.iconCategory = iconCategorySave
            category.colorCategory = colorCategorySave
            
        } else {
            categoryListItem.nameCategory = nameCategorySave
            categoryListItem.iconCategory = iconCategorySave
            categoryListItem.colorCategory = colorCategorySave
        }
        
        save(context: context)
        nameCategorySave = ""
        iconCategorySave = ""
        colorCategorySave = ""
        
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

