//
//  CategoryListView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 05.02.2022.
//

import SwiftUI
import CoreData

struct CategoryListView: View {
    
    @State private var showingNewCategory = false
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: CategoryEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CategoryEntity.nameCategory, ascending: true)])
    var cotegoryList: FetchedResults<CategoryEntity>
    
    
    var body: some View {
        List {
            ForEach(cotegoryList) { item in
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color(item.colorCategory!))
                            .frame(width: 32, height: 32)
                        Image(systemName: item.iconCategory!)
                            .foregroundColor(Color.white)
                            .font(Font.footnote)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(item.nameCategory!)
                            .bold()
                            .foregroundColor(.primary)
                    }
                    
                }
            }
        }
        
        .toolbar {
            
            ToolbarItemGroup(placement: .bottomBar) {
                Button(action: {
                    self.showingNewCategory.toggle()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .imageScale(.medium)
                        .font(.title)
                        .foregroundColor(Color(.blue))
                    Text("Категория").bold()
                }
                Spacer()
            }
            
        }
        
        .sheet(isPresented: $showingNewCategory) {
            
           NewCategoryView(showAddCategory: $showingNewCategory)
        }
       
    }
}

struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListView()
    }
}
