//
//  TransactionListView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 25.01.2022.
//

import SwiftUI

struct TransactionListView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var account: Account
    
    var body: some View {
        
            Text("\(account.nameAccount ?? "")")
            
                .navigationTitle(Text("\(account.nameAccount ?? "")"))
            
        
        
        
    }
}

struct TransactionListView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionListView(account: Account())
    }
}
