//
//  PanelView.swift
//  MoneyOK-iOS
//
//  Created by Ярослав Шерстюк on 31.01.2022.
//

import SwiftUI

struct PanelView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: AccountEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \AccountEntity.nameAccount, ascending: true)])
    private var fetchedAccount: FetchedResults<AccountEntity>
    
    @FetchRequest(entity: TransactionEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \TransactionEntity.sumTransaction, ascending: true)])
    private var fetchedTransaction: FetchedResults<TransactionEntity>
    
    @EnvironmentObject var accountListVM: AccountViewModel
    
    
    @State private var isNewAccount = false
    @State private var isNewTransaction = false
    
    // Складывает все транзакции
    var sumTransaction: Double {
        fetchedTransaction.reduce(0) { $0 + $1.sumTransaction }
    }
    
    var body: some View {
        
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text("Balance")
                        .font(.callout)
                        .foregroundColor(Color.gray)
                    // TODO: Добавить отображение суммы всех счетов
                    HStack {
                        Text("\(sumTransaction, format: .currency(code: Locale.current.currencyCode ?? "USD"))").bold()
                        //Text("$").bold() // Сделать валюту по умолчанию
                        
                    }.font(Font.title)
                }.padding(.horizontal)
                Spacer()
                Button {
                    self.isNewTransaction.toggle()
                } label: {
                    Image(systemName: "plus")
                        .padding()
                        .background(Color.blue)
                        .clipShape(Circle())
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal)
                }
                .contextMenu {
                    Button {
                        self.isNewTransaction.toggle()
                    } label: {
                        Label("New transaction", systemImage: "plus.circle")
                    }
                    Button {
                        accountListVM.nameAccountSave = ""
                        accountListVM.accountItem = nil
                        self.isNewAccount.toggle()
                    } label: {
                        Label("New account", systemImage: "plus.circle")
                    }
                }
            }
            
            .frame(maxWidth: .infinity)
            .padding(5)
            .background(Color(UIColor.secondarySystemBackground))
            
        
        
            .sheet(isPresented: $isNewAccount) {
                AccountNewView(isNewAccount: $isNewAccount)
            }
            .sheet(isPresented: $isNewTransaction) {
                TransactionNewView(accountItem: fetchedAccount.first!, isNewTransaction: $isNewTransaction, nowAccount: false)
            }
        
        
    }
}

struct PanelView_Previews: PreviewProvider {
    static var previews: some View {
        PanelView()
    }
}
