//
//  UpdateAccountView.swift
//  MoneyOK-iOS
//
//  Created by Ярослав Шерстюк on 25.01.2022.
//

import SwiftUI

struct UpdateAccountView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    
    var account: Account
    
    @State var updatedName: String = ""
    @State private var updatedStartBalance: Double = 0.0
    @State private var updatedNoteAccount: String = ""
    @State private var updatedColor: String = "swatch_shipcove"
    @State private var updatedIcon: String = "creditcard"
    
    @State private var isPresentedIcon: Bool = true
    
    
    // MARK: - Проверка введённых данных, если данные введены то кнопка сохранить доступна
    var disableForm: Bool {
        updatedName == ""
    }
    
    let formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter
        }()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack {
                        ZStack {
                            Circle()
                                .fill(Color(updatedColor))
                                .frame(width: 90, height: 90)
                                .padding()
                                .shadow(radius: 10)
                                .onAppear {
                                    // ℹ️ Set the text field's initial value when it appears
                                    self.updatedColor = self.account.colorAccount ?? ""
                                }
                            
                            Image(systemName: updatedIcon)
                                .font(Font.largeTitle)
                                .foregroundColor(Color.white)
                                .onAppear {
                                    // ℹ️ Set the text field's initial value when it appears
                                    self.updatedIcon = self.account.iconAccount ?? ""
                                }
                        }
                        
                        TextField("Name account", text: $updatedName)
                            .onAppear {
                                // ℹ️ Set the text field's initial value when it appears
                                self.updatedName = self.account.nameAccount ?? ""
                            }
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10.0)
                            .padding(.bottom)
                    }
                }
                Section(header: Text("Color")) {
                    ColorSwatchView(selection: $updatedColor)
                }
                Section(header: Text("Icon")) {
                    SFSymbolsPicker(isPresented: $isPresentedIcon, icon: $updatedIcon, category: .commerce, axis: .vertical, haptic: true).frame(height: 300)
                }
                Section(header: Text("Start balance"), footer: Text("Enter the initial balance of your account. From this balance the transaction tracking will begin")) {
                    TextField("Start balance", value: $updatedStartBalance, formatter: formatter)
                        .keyboardType(.decimalPad)
                        .onAppear {
                            // ℹ️ Set the text field's initial value when it appears
                            self.updatedStartBalance = self.account.balanceAccount
                        }
                }
                Section(header: Text("Note")) {
                    TextEditor(text: $updatedNoteAccount)
                        .onAppear {
                        // ℹ️ Set the text field's initial value when it appears
                            self.updatedNoteAccount = self.account.noteAccount ?? ""
                    }
                }
                
            }.dismissingKeyboard()
                
                .navigationTitle("New account")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(leading: Button("Cancel", action: {
                    self.presentationMode.projectedValue.wrappedValue.dismiss()
                }), trailing: Button(action: {
                    updateAccount()
                    self.presentationMode.projectedValue.wrappedValue.dismiss()
                }) {
                    Text("Update")
                }.disabled(disableForm)
                )
                
            
        }
        
    }
    
    private func updateAccount() {
        withAnimation {
            let newAccount = account
            newAccount.nameAccount = updatedName
            newAccount.colorAccount = updatedColor
            newAccount.iconAccount = updatedIcon
            newAccount.balanceAccount = updatedStartBalance
            newAccount.noteAccount = updatedNoteAccount
            PersistenceController.shared.saveContext()
        }
    }
}

struct UpdateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateAccountView(account: Account())
    }
}

