//
//  NotAccountView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 24.09.2022.
//

import SwiftUI
import CoreData

struct NotAccountsView: View {
    
    @EnvironmentObject var accountVM: AccountViewModel
    
    @State private var isNewAccount = false
    
    var body: some View {
        // Если нет счетов отображается пустой экран
        VStack {
            Image(systemName: "tray.2.fill")
                .font(.system(size: 80))
                .foregroundColor(.gray)
            Text("No accounts!")
                .font(.title3)
                .fontWeight(.bold)
                .padding()
            Text("To add a new account, click on the button below.")
                .font(.subheadline)
                .foregroundColor(Color.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30.0)
            Button {
                accountVM.nameAccountSave = ""
                accountVM.noteAccountSave = ""
                accountVM.accountItem = nil
                self.isNewAccount.toggle()
                
            } label: {
                HStack {
                    Image(systemName: "plus.circle.fill").font(.system(size: 22, weight: .bold))
                    Text("New account").bold()
                }
                .frame(width: 200, height: 40)
            }.buttonStyle(.borderedProminent)
                .padding()
        }
        .sheet(isPresented: $isNewAccount) {
            AccountNewView(isNewAccount: $isNewAccount)
        }
    }
}

struct NotAccountsView_Previews: PreviewProvider {
    static var previews: some View {
        NotAccountsView()
    }
}
