//
//  CategotyView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 09.02.2022.
//

import SwiftUI

struct CategotyView: View {
    
    @State private var isNewCategory = false

    
    var body: some View {
        CategoryListView()
            
                .navigationTitle("Категории")
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button(action: {
                            self.isNewCategory.toggle()
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .imageScale(.medium)
                                .font(.title)
                                .foregroundColor(Color.blue)
                            Text("Новая категория").bold()
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
