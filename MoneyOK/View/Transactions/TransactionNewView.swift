//
//  TransactionNewView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 09.02.2022.
//

import SwiftUI

struct TransactionNewView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var transactionVM: TransactionViewModel
    @EnvironmentObject var accountVM: AccountViewModel
    
    @ObservedObject var accountItem: AccountEntity
    
    @Binding var isNewTransaction: Bool
    @State var nowAccount: Bool
    
    @State private var selectedAccount: AccountEntity?
    @State private var selectedCategory: CategoryEntity?
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \AccountEntity.nameAccount, ascending: true)],animation:.default)
    private var fetchedAccount: FetchedResults<AccountEntity>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \CategoryEntity.nameCategory, ascending: true)],animation:.default)
    private var fetchedCategory: FetchedResults<CategoryEntity>
    
    let types = Array(TypeTransactionNew.allCases)
    @State var typeTransactionNew: TypeTransactionNew? = .costs
    
    @State private var personImage = UIImage()
    @State private var imagePicker = false
    
    // MARK: - Проверка введённых данных, если данные введены то кнопка сохранить доступна
        var disableForm: Bool {
            transactionVM.sumTransactionSave == 0.0 ||
            selectedCategory == nil
        }
    
    var body: some View {
        NavigationView {
            Form {
                Picker(selection: $typeTransactionNew, label: Text("Transaction categories")) {
                    ForEach(types, id: \.rawValue) {
                        Text($0.rawValue).tag(Optional<TypeTransactionNew>.some($0))
                    }
                }.pickerStyle(SegmentedPickerStyle())
                
                Section("Sum") {
                    HStack(alignment: .center) {
                        if typeTransactionNew == .costs {
                            Image(systemName: "minus.circle.fill")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(Color.red)
                        }
                        if typeTransactionNew == .income {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(Color.green)
                        }
                        
//                        if typeTransactionNew == .transfer {
//                            Image(systemName: "repeat.circle.fill")
//                                .font(.system(size: 32, weight: .bold))
//                                .foregroundColor(Color.blue)
//                        }
                        
                        TextField("", value: $transactionVM.sumTransactionSave, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                            .font(Font.system(size: 32, weight: .bold))
                            .keyboardType(.decimalPad)
                    }
                }
                
                
                
                
                    // MARK: Выбор счетов
                    if nowAccount == false {
                        Picker("Select an account", selection: $selectedAccount){
                            ForEach(fetchedAccount, id: \.self){ (account: AccountEntity) in
                                Text(account.nameAccount!).tag(account as AccountEntity?)
                            }
                        }
                    }
                    // MARK: Выбор категории
                    Picker("Select a category", selection: $selectedCategory){
                        if typeTransactionNew == .costs {
                            ForEach(fetchedCategory.filter{$0.isExpenses == false}){ (category: CategoryEntity) in
                                Text(category.nameCategory!).tag(category as CategoryEntity?)
                            }
                        }
                        
                        if typeTransactionNew == .income {
                            ForEach(fetchedCategory.filter{$0.isExpenses == true}){ (category: CategoryEntity) in
                                Text(category.nameCategory!).tag(category as CategoryEntity?)
                            }
                        }
                        
                    }
                
                
                
                Section("Advanced") {
                     
                    VStack {
                        DatePicker("Time", selection: $transactionVM.dateTransactionSave, in: ...Date(), displayedComponents: .date)
                            .environment(\.locale, Locale.init(identifier: "ru"))
                    }
                    HStack {
                        Text("Note")
                        TextEditor(text: $transactionVM.noteTransactionSave)
                    }
                    
                    Button {
                        self.imagePicker.toggle()
                    } label: {
                        Text("Image")
                    }
                    // TODO: Добавить отображение мини фото
//                    Image(uiImage: UIImage(data: personImage)!)
//                        .resizable()
//                        .clipShape(Circle())
//                        .frame(width: 60, height: 60)

                }
            }
            
            .safeAreaInset(edge: .bottom) {
                HStack {
                Button {
                    // MARK: Сохранение трензакции
                    transactionVM.createTransaction(context: viewContext, selectedAccount: (nowAccount ? accountItem : selectedAccount)!, selectedCategory: selectedCategory!, typeTransactionNew: typeTransactionNew!)
                    self.isNewTransaction.toggle()
                    
                    print("Session is cancelled")
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill").font(.system(size: 22, weight: .bold))
                        Text("Add").bold()
                    }
                    .frame(width: 300, height: 40)
                    
                
                }.buttonStyle(.borderedProminent)
                  
                }
                .padding(6)
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.secondarySystemBackground))
                .disabled(disableForm)
                    
            }
            .dismissingKeyboard()
            
            .navigationTitle("New transaction")
            .toolbar {
                ToolbarItem (placement: .navigationBarTrailing) {
                    Button() {
                        self.isNewTransaction.toggle()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $imagePicker){
                ImagePickerView(selectedImage: $personImage)
            }
        }
    }

}

// MARK: - Типы транзакции
enum TypeTransactionNew: String, CaseIterable {
    
    case costs = "Expense"
    case income = "Income"
    //case transfer = "Translation"
}

struct TransactionNewView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionNewView(accountItem: AccountEntity(), isNewTransaction: .constant(false), nowAccount: true)
    }
}
