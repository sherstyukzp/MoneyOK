//
//  DetailCategorySelectionView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 17.04.2022.
//

import SwiftUI

struct DetailCategorySelectionView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var transactionVM: TransactionViewModel
    @EnvironmentObject var categoryVM: CategoryViewModel
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.nameCategory, order: .forward)])
    private var fetchedCategory: FetchedResults<CategoryEntity>
 
    
    var body: some View {
        Form {
            if transactionVM.typeTransaction == .expenses {
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
                        if categoryVM.categorySelected == category {
                            Image(systemName: "checkmark").foregroundColor(Color.blue)
                        }
                    }
                    //====
                    .onTapGesture {
                        categoryVM.categorySelected = category
                        dismiss()
                    }
                }
            }
            
            if transactionVM.typeTransaction == .income {
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
                        if categoryVM.categorySelected == category {
                            Image(systemName: "checkmark").foregroundColor(Color.blue)
                        }
                    }
                    //====
                    .onTapGesture {
                        categoryVM.categorySelected = category
                        dismiss()
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
