//
//  CategoryViewModel.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 13.02.2022.
//

import Foundation
import CoreData


class CategoryViewModel: ObservableObject {
    
    @Published var nameCategorySave = ""
    @Published var iconCategorySave = "creditcard.fill"
    @Published var colorCategorySave = "swatch_articblue"
    
    @Published var categoryItem: CategoryEntity!
    
    
    func createCategory(context: NSManagedObjectContext) {
        
        if categoryItem == nil {
            let category = CategoryEntity(context: context)
            category.idCategory = UUID()
            category.nameCategory = nameCategorySave
            category.iconCategory = iconCategorySave
            category.colorCategory = colorCategorySave
            
        } else {
            categoryItem.nameCategory = nameCategorySave
            categoryItem.iconCategory = iconCategorySave
            categoryItem.colorCategory = colorCategorySave
        }
        
        save(context: context)
        nameCategorySave = ""
        iconCategorySave = "creditcard.fill"
        colorCategorySave = "swatch_articblue"
    }
    
    func editCategory(category: CategoryEntity){
        categoryItem = category
    }
    
    func delete(category: CategoryEntity, context: NSManagedObjectContext){
        context.delete(category)
        save(context: context)
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("🆘 Ошибка сохранения категории \(error.localizedDescription)")
        }
    }
    
    
}
