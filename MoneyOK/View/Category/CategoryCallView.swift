//
//  CategoryCallView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 09.02.2022.
//

import SwiftUI

struct CategoryCallView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var categoryItem: CategoryEntity
    
    
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
        
    }
}

struct CategoryCallView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryCallView(categoryItem: CategoryEntity())
    }
}
