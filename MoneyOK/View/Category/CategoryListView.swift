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
    @State var typeTrancaction: TypeTrancaction? = .expenses
    
    var body: some View {
        
        VStack {
            Picker(selection: $typeTrancaction, label: Text("Transaction categories")) {
                ForEach(types, id: \.rawValue) {
                    Text($0.localizedName).tag(Optional<TypeTrancaction>.some($0))
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            List {
                if typeTrancaction == .expenses {
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




struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListView()
    }
}
