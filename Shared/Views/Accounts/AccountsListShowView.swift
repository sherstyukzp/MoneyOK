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
    
    @FetchRequest(entity: AccountEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \AccountEntity.dateOfCreation, ascending: true)])
    var fetchAccounts: FetchedResults<AccountEntity>
    
    var body: some View {
        
        List {
            ForEach(fetchAccounts) { account in
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color(account.colorAccount!))
                            .frame(width: 32, height: 32)
                        Image(systemName: account.iconAccount!)
                            .foregroundColor(Color.white)
                            .font(Font.footnote)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(account.nameAccount!)
                            .bold()
                            .foregroundColor(.primary)
                        Text("Баланс: \(account.balanceAccount)")
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
