//
//  DetailAccountSelectionView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 17.04.2022.
//

import SwiftUI

struct DetailAccountSelectionView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @FetchRequest(sortDescriptors: [SortDescriptor(\.nameAccount, order: .forward)])
    private var fetchedAccount: FetchedResults<AccountEntity>
    
    @Binding var selectedItem: AccountEntity?
    
    var body: some View {
        Form {
            ForEach(fetchedAccount) { item in
//                AccountCallView(accountItem: item)
                //==
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color(item.colorAccount ?? "swatch_gunsmoke"))
                            .frame(width: 32, height: 32)
                        Image(systemName: item.iconAccount ?? "plus")
                            .foregroundColor(Color.white)
                            .font(Font.footnote)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(item.nameAccount ?? "no name")
                            .bold()
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    if self.selectedItem == item {
                        Image(systemName: "checkmark").foregroundColor(Color.blue)
                    }
                }
                //====
                    .onTapGesture {
                        self.selectedItem = item
                        self.presentationMode.wrappedValue.dismiss()
                    }
                
            }
        }
        .navigationTitle("Оберіть символ")
        
    }
}

//struct DetailAccountSelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailAccountSelectionView(selectedItem: .constant(AccountEntity.finalize()))
//    }
//}
