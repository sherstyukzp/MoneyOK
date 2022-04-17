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
    @EnvironmentObject var categoryVM: CategoryViewModel
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
    
    
    @State private var isNewCategory = false
    
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
                        // TODO: Добавить перевод
                        //                        if typeTransactionNew == .transfer {
                        //                            Image(systemName: "repeat.circle.fill")
                        //                                .font(.system(size: 32, weight: .bold))
                        //                                .foregroundColor(Color.blue)
                        //                        }
                        HStack {
                            TextField("", value: $transactionVM.sumTransactionSave, format: .number)
                            Text("$")
                        }
                        .font(Font.system(size: 32, weight: .bold))
                        .keyboardType(.decimalPad)
                    }
                }
                // MARK: Выбор счетов
                if nowAccount == false {
                    Section(header: Text("Select an account")) {
                        NavigationLink(destination: (
                            DetailAccountSelectionView(selectedItem: $selectedAccount)
                        ), label: {
                            HStack {
                                HStack {
                                    ZStack {
                                        Circle()
                                            .fill(Color(selectedAccount?.colorAccount ?? "swatch_gunsmoke"))
                                            .frame(width: 32, height: 32)
                                        Image(systemName: selectedAccount?.iconAccount ?? "plus")
                                            .foregroundColor(Color.white)
                                            .font(Font.footnote)
                                    }
                                    VStack(alignment: .leading) {
                                        Text(selectedAccount?.nameAccount ?? "Not selected account")
                                            .bold()
                                            .foregroundColor(.primary)
                                    }
                                }
                            }
                        })
                    }
                }
                // MARK: Выбор категории
                Section(header: Text("Select a category")) {
                    if fetchedCategory.isEmpty {
                        HStack {
                            Button {
                                categoryVM.nameCategorySave = ""
                                categoryVM.categoryItem = nil
                                self.isNewCategory.toggle()
                                
                            } label: {
                                HStack {
                                    Image(systemName: "plus.circle.fill").font(.system(size: 22, weight: .bold))
                                    Text("New Category").bold()
                                }
                                .frame(maxWidth: .infinity)
                                .padding(6)
                            }.buttonStyle(.borderedProminent)
                        }
                        .frame(maxWidth: .infinity)
                    } else {
                        NavigationLink(destination: (
                            DetailCategorySelectionView(selectedItem: $selectedCategory, typeTransaction: $typeTransactionNew)
                        ), label: {
                            HStack {
                                HStack {
                                    ZStack {
                                        Circle()
                                            .fill(Color(selectedCategory?.colorCategory ?? "swatch_gunsmoke"))
                                            .frame(width: 32, height: 32)
                                        Image(systemName: selectedCategory?.iconCategory ?? "plus")
                                            .foregroundColor(Color.white)
                                            .font(Font.footnote)
                                    }
                                    VStack(alignment: .leading) {
                                        Text(selectedCategory?.nameCategory ?? "Not selected category")
                                            .bold()
                                            .foregroundColor(.primary)
                                    }
                                }
                            }
                        })
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
                        if personImage.pngData() == nil {
                            self.imagePicker.toggle()
                        }
                        else {
                            personImage = UIImage()
                        }
                        
                    } label: {
                        HStack {
                            if personImage.pngData() == nil {
                                Text("Add image")
                            } else {
                                Text("Remove image")
                                    .foregroundColor(Color.red)
                            }
                            
                            Spacer()
                            Image(uiImage: personImage)
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                    }
                }
            }
            
            .safeAreaInset(edge: .bottom) {
                HStack {
                    Button {
                        // MARK: Сохранение трензакции
                        transactionVM.imageTransactionSave = personImage
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
            .sheet(isPresented: $isNewCategory) {
                CategoryNewView(isNewCategory: $isNewCategory)
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
