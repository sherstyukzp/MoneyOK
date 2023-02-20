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
    
    @State private var activeSheet: ActiveSheet?
    
    var body: some View {
        // Если нет счетов отображается пустой экран
        NavigationView {
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
                    accountVM.accountSelect = nil
                    activeSheet = .newAccount
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("New account")
                    }.font(.system(size: 20, weight: .bold))
                    .frame(width: 200, height: 40)
                }.buttonStyle(.borderedProminent)
                    .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .toolbar {
            // Кнопка Настройки в NavigationView
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    activeSheet = .settings
                } label: {
                    Image(systemName: "gearshape")
                }
            }
        }
        
        .sheet(item: $activeSheet) { item in
            switch item {
            case .newAccount:
                AccountNewView()
            case .settings:
                SettingsView()
            case .statistics:
                Text("statistics")
            case .transaction:
                Text("transaction")
            }
        }
    }
}

struct NotAccountsView_Previews: PreviewProvider {
    static var previews: some View {
        NotAccountsView()
    }
}
