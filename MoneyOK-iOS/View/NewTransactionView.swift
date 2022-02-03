//
//  NewTransactionView.swift
//  MoneyOK-iOS
//
//  Created by Ярослав Шерстюк on 31.01.2022.
//

import SwiftUI

struct NewTransactionView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \AccountEntity.nameAccount, ascending: true)]) private var accounts: FetchedResults<AccountEntity>
    
    @State private var selectedAccount = AccountEntity()
    
    let types = Array(TypeTrancaction.allCases)
    @State var typeTrancaction: TypeTrancaction? = .costs
    @State var sumTransaction: String = ""
    @State var noteTransaction: String = ""
    @State var dateTransaction: Date = Date()
    
    @Binding var showAddTransaction: Bool
    @State private var personImage = UIImage()
    @State private var imagePicker = false
    
    var body: some View {
        
        NavigationView {
            
            
            List {
                Picker(selection: $typeTrancaction, label: Text("Системы координат")) {
                    ForEach(types, id: \.rawValue) {
                        Text($0.rawValue).tag(Optional<TypeTrancaction>.some($0))
                    }
                }.pickerStyle(SegmentedPickerStyle())
                
                Section("Сумма") {
                    HStack(alignment: .center) {
                        if typeTrancaction == .costs {
                            Image(systemName: "minus.circle.fill")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(Color.red)
                        }
                        if typeTrancaction == .income {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(Color.green)
                        }
                        
                        if typeTrancaction == .transfer {
                            Image(systemName: "repeat.circle.fill")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(Color.blue)
                        }
                        
                        TextField("0", text: $sumTransaction)
                            .font(Font.system(size: 32, weight: .bold))
                    }
                }
                
                Section("Счёт") {
                    Picker("Выбрать счёт", selection: $selectedAccount){
                        ForEach(accounts, id: \.self) {
                            Text($0.nameAccount ?? "")
                            
                                .navigationBarTitle("Выберите счёт")
                        }
                    }
                }
                
                Section("Счёт") {
                    NavigationLink(destination: AccountsListShowView()) {
                        //
                        VStack {
                            Text("Счёт")
                                .bold()
                                .foregroundColor(Color.gray)
                            
                            Text("Нажмите чтобы выбрать")
                                .font(Font.footnote)
                                .foregroundColor(Color.gray)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                }
                
                Section("Категория") {
                    NavigationLink(destination: AccountsListShowView()) {
                        VStack {
                            Text("Категория")
                                .bold()
                                .foregroundColor(Color.gray)
                            
                            Text("Нажмите чтобы выбрать")
                                .font(Font.footnote)
                                .foregroundColor(Color.gray)
                        }
                        .frame(maxWidth: .infinity)
                        
                    }
                    
                }
                
                Section("Дополнительно") {
                     
                    VStack {
                        DatePicker("Время", selection:$dateTransaction).id(2)
                            .environment(\.locale, Locale.init(identifier: "ru"))
                    }
                    HStack {
                        Text("Заметки")
                        TextEditor(text: $noteTransaction)
                    }
                    
                    Button {
                        self.imagePicker.toggle()
                    } label: {
                        Text("Фото")
                    }
                    
//                    Image(uiImage: UIImage(data: personImage)!)
//                        .resizable()
//                        .clipShape(Circle())
//                        .frame(width: 60, height: 60)

                }
            
            }
            .dismissingKeyboard()
            .sheet(isPresented: $imagePicker){
                ImagePickerView(selectedImage: $personImage)
            }
            

            .safeAreaInset(edge: .bottom) {
                HStack {
                Button {
                    print("Session is cancelled")
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill").font(.system(size: 22, weight: .bold))
                        Text("Добавить").bold()
                    }
                    .frame(width: 300, height: 40)
                    
                
                }.buttonStyle(.borderedProminent)
//                        .shadow(color: Color.black.opacity(0.2),
//                                radius: 2,
//                                x: 2,
//                                y: 2)
                  
                }
                .padding(6)
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.secondarySystemBackground))
                    
            }
            
            
            
                .navigationTitle("Новая транзакция")
                .toolbar {
                    ToolbarItem (placement: .navigationBarTrailing) {
                        
                        Button() {
                            self.showAddTransaction.toggle()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                        }

                        
                    }
                }
        }
        
    }
}

// MARK: - Типы транзакции
enum TypeTrancaction: String, CaseIterable {
    
    case costs = "Расход"
    case income = "Доход"
    case transfer = "Перевод"
}

struct NewTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        NewTransactionView(showAddTransaction: .constant(false))
    }
}
