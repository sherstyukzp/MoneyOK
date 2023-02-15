//
//  AccountNewView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 09.02.2022.
//

import SwiftUI

struct AccountNewView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var accountVM: AccountViewModel
    
    @Binding var isNewAccount: Bool
    
    @State private var isPresentedIcon: Bool = true
    
    // MARK: - Проверка введённых данных, если данные введены то кнопка сохранить доступна
    var disableForm: Bool {
        accountVM.accountModel.nameAccount.isEmpty ||
        accountVM.accountModel.iconAccount.isEmpty ||
        accountVM.accountModel.colorAccount.isEmpty
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack {
                        ZStack {
                            Circle()
                                .fill(Color(accountVM.accountModel.colorAccount.isEmpty ? "swatch_articblue" : accountVM.accountModel.colorAccount))
                                .frame(width: 90, height: 90)
                                .shadow(radius: 10)
                                .padding()
                            Image(systemName: accountVM.accountModel.iconAccount.isEmpty ? "creditcard.fill" : accountVM.accountModel.iconAccount)
                                .font(Font.largeTitle)
                                .foregroundColor(Color.white)
                        }
                        
                        TextField("Name account", text: $accountVM.accountModel.nameAccount)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10.0)
                            .padding(.bottom)
                    }
                }
                Section(header: Text("Color")) {
                    ColorSwatchView(selection: $accountVM.accountModel.colorAccount)
                }
                Section(header: Text("Icon")) {
                    SFSymbolsPicker(isPresented: $isPresentedIcon, icon: $accountVM.accountModel.iconAccount, category: .accounts , axis: .vertical, haptic: true).frame(height: 300)
                }
                
                Section(header: Text("Note")) {
                    TextEditor(text: $accountVM.accountModel.noteAccount)
                }
                
                if accountVM.accountItem != nil {
                    Section(header: Text("Date of creation")) {
                        Text(accountVM.accountModel.dateOfCreationSave, style: .date)
                    }
                }
                
                
            }.dismissingKeyboard()
            
                .navigationTitle(accountVM.accountItem == nil ? "New" : "Edit")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            accountVM.createAccount(context: viewContext)
                            self.isNewAccount.toggle()
                        }) {
                            Text(accountVM.accountItem == nil ? "Save" : "Update")
                        }.disabled(disableForm)
                    }
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            self.isNewAccount.toggle()
                        }) {
                            Text("Cancel").bold()
                                .foregroundColor(Color.blue)
                        }
                    }
                }
        }
    }
}

struct AccountNewView_Previews: PreviewProvider {
    static var previews: some View {
        AccountNewView(isNewAccount: .constant(false))
    }
}
