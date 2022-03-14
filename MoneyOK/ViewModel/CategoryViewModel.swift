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
    @Published var isExpensesCategorySave = true
    
    @Published var categoryItem: CategoryEntity!
    
    
    func createCategory(context: NSManagedObjectContext) {
        
        if categoryItem == nil {
            let category = CategoryEntity(context: context)
            category.idCategory = UUID()
            category.nameCategory = nameCategorySave
            category.iconCategory = iconCategorySave
            category.colorCategory = colorCategorySave
            category.isExpenses = isExpensesCategorySave
            
        } else {
            categoryItem.nameCategory = nameCategorySave
            categoryItem.iconCategory = iconCategorySave
            categoryItem.colorCategory = colorCategorySave
            categoryItem.isExpenses = isExpensesCategorySave
        }
        
        save(context: context)
        nameCategorySave = ""
        iconCategorySave = ""
        colorCategorySave = ""
        isExpensesCategorySave = true
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
