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
    
    @EnvironmentObject var transactionListVM: TransactionViewModel
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \AccountEntity.nameAccount, ascending: true)]) private var accounts: FetchedResults<AccountEntity>
    
    @State private var selectedAccount = AccountEntity()
    
    let types = Array(TypeTrancaction.allCases)
    @State var typeTrancaction: TypeTrancaction? = .costs
    @State var sumTransaction: Double = 0
    @State var noteTransaction: String = ""
    @State var dateTransaction: Date = Date()
    
    @Binding var showAddTransaction: Bool
    @State private var personImage = UIImage()
    @State private var imagePicker = false
    
    @ObservedObject var accountSelect: AccountEntity
    
    
    
    // MARK: - Проверка введённых данных, если данные введены то кнопка сохранить доступна
//        var disableForm: Bool {
//            sumTransaction.isEmpty
//        }
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var body: some View {
        
        NavigationView {
            List {
                Picker(selection: $typeTrancaction, label: Text("Категории транзакций")) {
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
                        
                        TextField("0", value: $sumTransaction, formatter: formatter)
                            .font(Font.system(size: 32, weight: .bold))
                            .keyboardType(.decimalPad)
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
                
                Section("Категория") {
                    Picker("Выбрать категорию", selection: $selectedAccount){
                        ForEach(accounts, id: \.self) {
                            Text($0.nameAccount ?? "")

                                .navigationBarTitle("Выберите категорию")
                        }
                    }
                }
                
//                Section("Счёт") {
//                    NavigationLink(destination: AccountsListShowView()) {
//                        VStack {
//                            Text("Счёт")
//                                .bold()
//                                .foregroundColor(Color.gray)
//
//                            Text("Нажмите чтобы выбрать")
//                                .font(Font.footnote)
//                                .foregroundColor(Color.gray)
//                        }
//                        .frame(maxWidth: .infinity)
//                    }
//
//                }
                
//                Section("Категория") {
//                    NavigationLink(destination: AccountsListShowView()) {
//                        VStack {
//                            Text("Категория")
//                                .bold()
//                                .foregroundColor(Color.gray)
//
//                            Text("Нажмите чтобы выбрать")
//                                .font(Font.footnote)
//                                .foregroundColor(Color.gray)
//                        }
//                        .frame(maxWidth: .infinity)
//
//                    }
//
//                }
                
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
                    // TODO: Добавить отображение мини фото
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
                    // TODO: Добавить сохранение транзакции
                    //transactionListVM.createTransaction(context: viewContext, selectAccount: selectedAccount)
                    addEmployee()
                    self.showAddTransaction.toggle()
                    
                    print("Session is cancelled")
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill").font(.system(size: 22, weight: .bold))
                        Text("Добавить").bold()
                    }
                    .frame(width: 300, height: 40)
                    
                
                }.buttonStyle(.borderedProminent)
                  
                }
                .padding(6)
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.secondarySystemBackground))
                //.disabled(disableForm)
                    
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
    
    private func addEmployee(){
        let newEmployee = Transaction(context: viewContext)
        newEmployee.idTransaction = UUID()
        newEmployee.sumTransaction = sumTransaction
        newEmployee.accounts = selectedAccount
        do{
            try viewContext.save()
        }
        catch{
            print("Error while saving Employee Data \(error.localizedDescription)")
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
        NewTransactionView(showAddTransaction: .constant(false), accountSelect: AccountEntity())
    }
}
