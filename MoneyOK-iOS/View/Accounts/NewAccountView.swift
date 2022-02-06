//
//  NewAccountView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 21.01.2022.
//

import SwiftUI

struct NewAccountView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    @EnvironmentObject var accountListVM: AccountViewModel
    
    @Binding var showAddAccount: Bool
    
    @State private var isPresentedIcon: Bool = true
    
    
    // MARK: - Проверка введённых данных, если данные введены то кнопка сохранить доступна
        var disableForm: Bool {
            accountListVM.nameAccountSave.isEmpty ||
            accountListVM.iconAccountSave.isEmpty ||
            accountListVM.colorAccountSave.isEmpty
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
                                .fill(Color(accountListVM.colorAccountSave.isEmpty ? "swatch_articblue" : accountListVM.colorAccountSave))
                                .frame(width: 90, height: 90)
                                .shadow(radius: 10)
                                .padding()
                            Image(systemName: accountListVM.iconAccountSave.isEmpty ? "creditcard.fill" : accountListVM.iconAccountSave)
                                .font(Font.largeTitle)
                                .foregroundColor(Color.white)
                        }
                        
                        
                        TextField("Имя счёта", text: $accountListVM.nameAccountSave)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10.0)
                            .padding(.bottom)
                    }
                }
                Section(header: Text("Цвет")) {
                    
                    ColorSwatchView(selection: $accountListVM.colorAccountSave)
                }
                Section(header: Text("Иконка")) {
                    SFSymbolsPicker(isPresented: $isPresentedIcon, icon: $accountListVM.iconAccountSave, category: .commerce, axis: .vertical, haptic: true).frame(height: 300)
                }
                Section(header: Text("Баланс"), footer: Text("Введите начальный баланс вашеего счёта. От этого баланса начнется отслеживание транзакций")) {
                    TextField("Баланс", value: $accountListVM.balanceAccountSave, formatter: formatter)
                        .keyboardType(.decimalPad)
                }
                Section(header: Text("Заметки")) {
                    TextEditor(text: $accountListVM.noteAccountSave)
                }
                
            }.dismissingKeyboard()
            
                .navigationTitle(accountListVM.accountListItem == nil ? "Новый" : "Редактировать")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(leading: Button("Отмена", action: {
                    self.showAddAccount.toggle()
                }), trailing: Button(action: {
                    accountListVM.createTask(context: viewContext)
                    self.showAddAccount.toggle()
                }) {
                    Text(accountListVM.accountListItem == nil ? "Сохранить" : "Обновить")
                }.disabled(disableForm)
                )
        }
    }
}

struct NewAccountView_Previews: PreviewProvider {
    static var previews: some View {
        NewAccountView(showAddAccount: .constant(false))
    }
}
