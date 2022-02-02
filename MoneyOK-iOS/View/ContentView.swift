//
//  ContentView.swift
//  MoneyOK-iOS
//
//  Created by Ярослав Шерстюк on 21.01.2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: AccountEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \AccountEntity.dateOfCreation, ascending: true)])
    var accountList: FetchedResults<AccountEntity>
    
    @EnvironmentObject var accountListVM: AccountViewModel
    
    @State private var showingNewAccount = false
    
    var body: some View {
        NavigationView {
            
            VStack {
            if accountList.count == 0 {
                
                VStack {
                    Image(systemName: "tray.2.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.gray)
                    Text("Нет счетов!")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding()
                    Text("Для добавление нового счёта нажмите на кнопку ниже.")
                        .font(.subheadline)
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30.0)
                    Button {
                        accountListVM.nameAccountSave = ""
                        accountListVM.accountListItem = nil
                        self.showingNewAccount.toggle()
                        
                    } label: {
                        Text("Новый счёт")
                    }

                }
            } else {
            VStack {
                SidebarView()
                    .safeAreaInset(edge: .bottom) {
                            PanelView()
                            }
            }
            }
            
            }
            
            .sheet(isPresented: $showingNewAccount) {
                    NewAccountView(showAdd: $showingNewAccount)
                }
            .toolbar {
                    // Кнопка Настройки
                ToolbarItem(placement: .navigationBarLeading) {
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gearshape")
                        }
                    }
            }
                
            
                .navigationTitle("MoneyOK")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
