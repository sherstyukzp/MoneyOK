//
//  DetailAccountSelectionView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 17.04.2022.
//

import SwiftUI

struct DetailAccountSelectionView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.nameAccount, order: .forward)])
    private var fetchedAccount: FetchedResults<AccountEntity>
    
    @EnvironmentObject var accountVM: AccountViewModel
    
    var body: some View {
        Form {
            ForEach(fetchedAccount) { item in
                AccountCallView(accountItem: item)
                
                .onTapGesture {
                        accountVM.accountSelect = item
                        dismiss()
                    }
                
            }
        }
        .navigationTitle("Select an account")
        
    }
}

struct DetailAccountSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        DetailAccountSelectionView()
    }
}
