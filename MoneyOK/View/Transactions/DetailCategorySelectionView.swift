//
//  DetailCategorySelectionView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 17.04.2022.
//

import SwiftUI

struct DetailCategorySelectionView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @FetchRequest(sortDescriptors: [SortDescriptor(\.nameCategory, order: .forward)])
    private var fetchedCategory: FetchedResults<CategoryEntity>
    
    @Binding var selectedItem: CategoryEntity?
    @Binding var typeTransaction: TypeTrancaction
    
    
    var body: some View {
        Form {
            if typeTransaction == .expenses {
                ForEach(fetchedCategory.filter{$0.isExpenses == false}){ (category: CategoryEntity) in
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color(category.colorCategory ?? "swatch_gunsmoke"))
                                .frame(width: 32, height: 32)
                            Image(systemName: category.iconCategory ?? "plus")
                                .foregroundColor(Color.white)
                                .font(Font.footnote)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(category.nameCategory ?? "no name")
                                .bold()
                                .foregroundColor(.primary)
                        }
                        
                        Spacer()
                        if self.selectedItem == category {
                            Image(systemName: "checkmark").foregroundColor(Color.blue)
                        }
                    }
                    //====
                    .onTapGesture {
                        self.selectedItem = category
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            
            if typeTransaction == .income {
                ForEach(fetchedCategory.filter{$0.isExpenses == true}){ (category: CategoryEntity) in
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color(category.colorCategory ?? "swatch_gunsmoke"))
                                .frame(width: 32, height: 32)
                            Image(systemName: category.iconCategory ?? "plus")
                                .foregroundColor(Color.white)
                                .font(Font.footnote)
                        }
                        VStack(alignment: .leading) {
                            Text(category.nameCategory ?? "no name")
                                .bold()
                                .foregroundColor(.primary)
                        }
                        Spacer()
                        if self.selectedItem == category {
                            Image(systemName: "checkmark").foregroundColor(Color.blue)
                        }
                    }
                    //====
                    .onTapGesture {
                        self.selectedItem = category
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .navigationTitle("Select a caregory")
    }
}

//struct DetailCategorySelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailCategorySelectionView()
//    }
//}
