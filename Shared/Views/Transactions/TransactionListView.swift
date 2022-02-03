//
//  TransactionListView.swift
//  MoneyOK-iOS
//
//  Created by Ярослав Шерстюк on 03.02.2022.
//

import SwiftUI

struct TransactionListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var area: AccountEntity
    
    @State private var showingNewTransaction = false
    
    var body: some View {
        List {
            Text("Hello, SwiftUI!")
        }
            
            
            .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        VStack {
                            Text(area.nameAccount!)
                                .font(.headline)
                                .foregroundColor(Color(area.colorAccount!))
                            Text("\(area.balanceAccount)").font(.subheadline)
                        }
                    }
                    
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button(action: {
                                self.showingNewTransaction.toggle()
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .imageScale(.medium)
                                    .font(.title)
                                    .foregroundColor(Color(area.colorAccount!))
                                Text("Транзакция").bold()
                                    .foregroundColor(Color(area.colorAccount!))
                            }
                        Spacer()
                        }
                }
        
                .sheet(isPresented: $showingNewTransaction) {
                        NewTransactionView(showAddTransaction: $showingNewTransaction)
                    }
        
    }
}

struct TransactionListView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionListView(area: AccountEntity())
    }
}
