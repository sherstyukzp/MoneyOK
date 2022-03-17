//
//  CategoryListView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 09.02.2022.
//

import SwiftUI

struct CategoryListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \CategoryEntity.nameCategory, ascending: true)])
    private var fetchedCategory:FetchedResults<CategoryEntity>
    
    let types = Array(TypeTrancaction.allCases)
    @State var typeTrancaction: TypeTrancaction? = .costs
    
    var body: some View {
        
        VStack {
            Picker(selection: $typeTrancaction, label: Text("Transaction categories")) {
                ForEach(types, id: \.rawValue) {
                    Text($0.rawValue).tag(Optional<TypeTrancaction>.some($0))
                }
            }
            .padding(.horizontal)
            .pickerStyle(SegmentedPickerStyle())
            
            List {
                if typeTrancaction == .costs {
                    ForEach(fetchedCategory.filter{$0.isExpenses == false}) { category in
                        CategoryCallView(categoryItem: category)
                        
                    }
                }
                if typeTrancaction == .income {
                    ForEach(fetchedCategory.filter{$0.isExpenses == true}) { category in
                        CategoryCallView(categoryItem: category)
                        
                    }
                }
                
            }
        }
        
        
        
    }
}


// MARK: - Типы транзакции
enum TypeTrancaction: String, CaseIterable {
    
    case costs = "Expense"
    case income = "Income"
}

struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListView()
    }
}
