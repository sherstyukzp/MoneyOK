//
//  AccountsListShowView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 02.02.2022.
//

import SwiftUI
import CoreData

struct AccountsListShowView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    
    @FetchRequest(entity: AccountEntity.entity(), sortDescriptors: [NSSortDescriptor(key: "dateOfCreation", ascending: true)])
    var accountList: FetchedResults<AccountEntity>
    
    var body: some View {
        
        List {
            ForEach(accountList) { item in
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color(item.colorAccount!))
                            .frame(width: 32, height: 32)
                        Image(systemName: item.iconAccount!)
                            .foregroundColor(Color.white)
                            .font(Font.footnote)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(item.nameAccount!)
                            .bold()
                            .foregroundColor(.primary)
                        Text("Баланс: \(item.balanceAccount)")
                                    .font(Font.footnote).foregroundColor(Color.gray)
                    }
                    
                }
            }
        }
        .navigationTitle("Счета")
        
    }
}

struct AccountsListShowView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsListShowView()
    }
}
