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
    
    @Binding var showAdd: Bool
    
//    @State private var nameAccount: String = ""
    @State private var startBalance: Double = 0.0
    @State private var noteAccount: String = ""
//    @State private var dateOfCreation = Date()
//
    @State private var selectionColor: String = "swatch_shipcove"
    @State private var selectionIcon: String = "creditcard"
    @State private var isPresentedIcon: Bool = true
    
    
    // MARK: - Проверка введённых данных, если данные введены то кнопка сохранить доступна
//    var disableForm: Bool {
//        nameAccount == ""
//    }
    
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
                            // TODO: Добавить цвет
                                .fill(Color.blue)
                                .frame(width: 90, height: 90)
                                .shadow(radius: 10)
                                .padding()
                            // TODO: Добавить иконку
                            Image(systemName: "plus")
                                .font(Font.largeTitle)
                                .foregroundColor(Color.white)
                        }
                        
                        TextField("Name account", text: $accountListVM.accountListTitle)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10.0)
                            .padding(.bottom)
                    }
                }
                Section(header: Text("Color")) {
                    // TODO: Добавить цвет
                    ColorSwatchView(selection: $selectionColor)
                }
                Section(header: Text("Icon")) {
                    SFSymbolsPicker(isPresented: $isPresentedIcon, icon: $selectionIcon, category: .commerce, axis: .vertical, haptic: true).frame(height: 300)
                }
                Section(header: Text("Start balance"), footer: Text("Enter the initial balance of your account. From this balance the transaction tracking will begin")) {
                    TextField("Start balance", value: $startBalance, formatter: formatter)
                        .keyboardType(.decimalPad)
                }
                Section(header: Text("Note")) {
                    TextEditor(text: $noteAccount)
                }
                
            }.dismissingKeyboard()
                
                .navigationTitle(accountListVM.accountListItem == nil ? "Add Account" : "Edit Account")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(leading: Button("Cancel", action: {
                    self.showAdd.toggle()
                }), trailing: Button(action: {
                    accountListVM.createTask(context: viewContext)
                    self.showAdd.toggle()
                }) {
                    Text("Save")
                }//.disabled(disableForm)
                )
                
            
        }
        
    }
    

}

struct NewAccountView_Previews: PreviewProvider {
    static var previews: some View {
        NewAccountView(showAdd: .constant(false))
    }
}
