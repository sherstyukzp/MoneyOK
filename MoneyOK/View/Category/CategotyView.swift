//
//  CategotyView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 09.02.2022.
//

import SwiftUI

struct CategotyView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \CategoryEntity.nameCategory, ascending: true)])
    private var fetchedCategory:FetchedResults<CategoryEntity>
    
    @EnvironmentObject var categoryVM: CategoryViewModel
    
    @State private var isNewCategory = false
    
    var body: some View {
        
        VStack {
            if fetchedCategory.isEmpty {
                Image(systemName: "tray.2.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.gray)
                Text("No category!")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                Text("To add a new category, click on the '' New Category '' button.")
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30.0)
            } else {
                CategoryListView()
            }
            
        }
        
            
                .navigationTitle("Categories")
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button(action: {
                            categoryVM.nameCategorySave = ""
                            categoryVM.categorySelected = nil
                            self.isNewCategory.toggle()
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .imageScale(.medium)
                                .font(.title)
                                .foregroundColor(Color.blue)
                            Text("New category").bold()
                                .foregroundColor(Color.blue)
                        }
                        Spacer()
                    }
                }
                .sheet(isPresented: $isNewCategory) {
                    CategoryNewView(isNewCategory: $isNewCategory)
                }
    }
}









struct CategotyView_Previews: PreviewProvider {
    static var previews: some View {
        CategotyView()
    }
}
