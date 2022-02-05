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


    @Published var categoryCostsListItem: CategoryCosts!
    
    func createCategoryCosts(context: NSManagedObjectContext) {
        
        if categoryCostsListItem == nil {
            let account = CategoryCosts(context: context)
            account.idCategoryCosts = UUID()
            account.nameCategory = nameCategoryCostsSave
            account.iconCategory = iconCategoryCostsSave
            account.colorCategory = colorCategoryCostsSave
            
        } else {
            categoryCostsListItem.nameCategory = nameCategoryCostsSave
            categoryCostsListItem.iconCategory = iconCategoryCostsSave
            categoryCostsListItem.colorCategory = colorCategoryCostsSave
        }
        
        save(context: context)
        nameCategoryCostsSave = ""
        iconCategoryCostsSave = ""
        colorCategoryCostsSave = ""
        
    }
    
    
    func editList(category: CategoryCosts){
        categoryCostsListItem = category
    }
    
    func delete(category: CategoryCosts, context: NSManagedObjectContext) {
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

