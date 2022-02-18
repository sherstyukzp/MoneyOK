//
//  CategoryCallView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 09.02.2022.
//

import SwiftUI

struct CategoryCallView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var categoryVM: CategoryViewModel
    @ObservedObject var categoryItem: CategoryEntity
    
    @State private var isEditCategory = false // Вызов редактирования категории
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(Color(categoryItem.colorCategory ?? "swatch_articblue"))
                    .frame(width: 32, height: 32)
                Image(systemName: categoryItem.iconCategory ?? "creditcard.fill")
                    .foregroundColor(Color.white)
                    .font(Font.footnote)
            }
            
            VStack(alignment: .leading) {
                Text(categoryItem.nameCategory ?? "")
                    .bold()
                    .foregroundColor(.primary)
                
            }
            Spacer()
            Text("\(categoryItem.categoryToTransaction?.count ?? 0)")
                .font(.footnote)
            
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            
            Button {
                categoryVM.nameCategorySave = categoryItem.nameCategory!
                categoryVM.iconCategorySave = categoryItem.iconCategory!
                categoryVM.colorCategorySave = categoryItem.colorCategory!
                
                categoryVM.categoryItem = categoryItem
                self.isEditCategory.toggle()
            } label: {
                Label("Редактировать", systemImage: "pencil")
            }.tint(.yellow)
            
        }
        
        .sheet(isPresented: $isEditCategory) {
            CategoryNewView(isNewCategory: $isEditCategory)
        }
        
    }
}

struct CategoryCallView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryCallView(categoryItem: CategoryEntity())
    }
}
