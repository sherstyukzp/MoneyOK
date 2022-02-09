//
//  NewAccountView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 21.01.2022.
//

import SwiftUI

struct NewAccountView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    @EnvironmentObject var accountVM: AccountViewModel
    
    @Binding var isAddAccount: Bool
    
    @State private var isPresentedIcon: Bool = true
    
    
    // MARK: - Проверка введённых данных, если данные введены то кнопка сохранить доступна
        var disableForm: Bool {
            accountVM.nameAccountSave.isEmpty ||
            accountVM.iconAccountSave.isEmpty ||
            accountVM.colorAccountSave.isEmpty
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
                                .fill(Color(accountVM.colorAccountSave.isEmpty ? "swatch_articblue" : accountVM.colorAccountSave))
                                .frame(width: 90, height: 90)
                                .shadow(radius: 10)
                                .padding()
                            Image(systemName: accountVM.iconAccountSave.isEmpty ? "creditcard.fill" : accountVM.iconAccountSave)
                                .font(Font.largeTitle)
                                .foregroundColor(Color.white)
                        }
                        
                        TextField("Имя счёта", text: $accountVM.nameAccountSave)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10.0)
                            .padding(.bottom)
                    }
                }
                Section(header: Text("Цвет")) {
                    ColorSwatchView(selection: $accountVM.colorAccountSave)
                }
                Section(header: Text("Иконка")) {
                    SFSymbolsPicker(isPresented: $isPresentedIcon, icon: $accountVM.iconAccountSave, category: .commerce, axis: .vertical, haptic: true).frame(height: 300)
                }
                Section(header: Text("Баланс"), footer: Text("Введите начальный баланс вашеего счёта. От этого баланса начнется отслеживание транзакций")) {
                    TextField("Баланс", value: $accountVM.balanceAccountSave, formatter: formatter)
                        .keyboardType(.decimalPad)
                }
                Section(header: Text("Заметки")) {
                    TextEditor(text: $accountVM.noteAccountSave)
                }
                
            }.dismissingKeyboard()
            
                .navigationTitle(accountVM.accountListItem == nil ? "Новый" : "Редактировать")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(leading: Button("Отмена", action: {
                    self.isAddAccount.toggle()
                }), trailing: Button(action: {
                    accountVM.createTask(context: viewContext)
                    self.isAddAccount.toggle()
                }) {
                    Text(accountVM.accountListItem == nil ? "Сохранить" : "Обновить")
                }.disabled(disableForm)
                )
        }
    }
}

struct NewAccountView_Previews: PreviewProvider {
    static var previews: some View {
        NewAccountView(isAddAccount: .constant(false))
    }
}
