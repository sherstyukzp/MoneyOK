//
//  PanelView.swift
//  MoneyOK-iOS
//
//  Created by Ярослав Шерстюк on 31.01.2022.
//

import SwiftUI

struct PanelView: View {
    
    @EnvironmentObject var accountListVM: AccountViewModel
    
    
    @State private var showingNewAccount = false
    @State private var showingNewTransaction = false
    
    var body: some View {
        
        
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text("Остаток")
                    .font(.callout)
                    .foregroundColor(Color.gray)
                // TODO: Добавить отображение суммы всех счетов
                HStack {
                    Text("123456").bold()
                    Text("$").bold() // Сделать валюту по умолчанию
                        
                }.font(Font.largeTitle)
            }.padding(.horizontal)
            Spacer()
            Button {
                self.showingNewTransaction.toggle()
            } label: {
                Image(systemName: "plus")
                    .padding()
                    .background(Color.blue)
                    .clipShape(Circle())
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal)
//                    .shadow(color: Color.black.opacity(0.2),
//                            radius: 2,
//                            x: 2,
//                            y: 2)
            }
            .contextMenu {
                    Button {
                        self.showingNewTransaction.toggle()
                    } label: {
                        Label("Новая транзакция", systemImage: "plus.circle")
                    }
                    Button {
                        accountListVM.nameAccountSave = ""
                        accountListVM.accountListItem = nil
                        self.showingNewAccount.toggle()
                    } label: {
                        Label("Новый счёт", systemImage: "plus.circle")
                    }
                    
                }
        }
        .frame(maxWidth: .infinity)
        .padding(5)
        .background(Color(UIColor.secondarySystemBackground))
        
        .sheet(isPresented: $showingNewAccount) {
                NewAccountView(isAddAccount: $showingNewAccount)
            }
        .sheet(isPresented: $showingNewTransaction) {
            NewTransactionView(showAddTransaction: $showingNewTransaction)
            }
    
    }
}

struct PanelView_Previews: PreviewProvider {
    static var previews: some View {
        PanelView()
    }
}
