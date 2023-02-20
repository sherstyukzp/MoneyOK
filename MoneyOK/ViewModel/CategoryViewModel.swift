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
    
    @Published var categorySelected: CategoryEntity!
    
    
    func createCategory(context: NSManagedObjectContext) {
        
        if categorySelected == nil {
            let category = CategoryEntity(context: context)
            category.idCategory = UUID()
            category.nameCategory = nameCategorySave
            category.iconCategory = iconCategorySave
            category.colorCategory = colorCategorySave
            category.isExpenses = isExpensesCategorySave
            
        } else {
            categorySelected.nameCategory = nameCategorySave
            categorySelected.iconCategory = iconCategorySave
            categorySelected.colorCategory = colorCategorySave
            categorySelected.isExpenses = isExpensesCategorySave
        }
        
        save(context: context)
        nameCategorySave = ""
        iconCategorySave = ""
        colorCategorySave = ""
        isExpensesCategorySave = true
    }
    
    func editCategory(category: CategoryEntity){
        categorySelected = category
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
