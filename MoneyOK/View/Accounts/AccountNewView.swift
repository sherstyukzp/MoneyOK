//
//  AccountNewView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 09.02.2022.
//

import SwiftUI

struct AccountNewView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var accountVM: AccountViewModel
    
    @State private var isPresentedIcon: Bool = true
    
    // MARK: - Проверка введённых данных, если данные введены то кнопка сохранить доступна
    var disableForm: Bool {
        accountVM.nameAccount.isEmpty ||
        accountVM.iconAccount.isEmpty ||
        accountVM.colorAccount.isEmpty
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack {
                        ZStack {
                            Circle()
                                .fill(Color(accountVM.colorAccount.isEmpty ? "swatch_articblue" : accountVM.colorAccount))
                                .frame(width: 90, height: 90)
                                .shadow(radius: 10)
                                .padding()
                            Image(systemName: accountVM.iconAccount.isEmpty ? "creditcard.fill" : accountVM.iconAccount)
                                .font(Font.largeTitle)
                                .foregroundColor(Color.white)
                        }
                        HStack {
                            TextField("Name account", text: $accountVM.nameAccount)
                            Picker("", selection: $accountVM.selectedCurrency) {
                                ForEach(Currency.allCases, id: \.self) { currency in
                                    Text(currency.localizedName)
                                        .tag(currency)
                                }
                            }
                            .pickerStyle(.menu)
                        }.padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10.0)
                            .padding(.bottom)
                        
                    }
                }
                Section(header: Text("Color")) {
                    ColorSwatchView(selection: $accountVM.colorAccount)
                }
                Section(header: Text("Icon")) {
                    SFSymbolsPicker(isPresented: $isPresentedIcon, icon: $accountVM.iconAccount, category: .accounts , axis: .vertical, haptic: true).frame(height: 300)
                }
                
                Section(header: Text("Note")) {
                    TextEditor(text: $accountVM.noteAccount)
                }
                
                if accountVM.accountSelect != nil {
                    Section(header: Text("Date of creation")) {
                        Text(accountVM.dateOfCreationSave, style: .date)
                    }
                }
                
                
            }.dismissingKeyboard()
            
                .navigationTitle(accountVM.accountSelect == nil ? "New" : "Edit")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            accountVM.createAccount(context: viewContext)
                            dismiss()
                        }) {
                            Text(accountVM.accountSelect == nil ? "Save" : "Update")
                        }.disabled(disableForm)
                    }
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dismiss()
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
        AccountNewView()
    }
}
