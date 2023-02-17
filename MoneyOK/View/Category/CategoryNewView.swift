//
//  CategoryNewView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 09.02.2022.
//

import SwiftUI

struct CategoryNewView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var categoryVM: CategoryViewModel
    
    @Binding var isNewCategory: Bool
    
    @State private var isPresentedIcon: Bool = true
    
    let types = Array(TypeTrancaction.allCases)
    @State var typeTrancaction: TypeTrancaction? = .expenses

    
    // MARK: - Проверка введённых данных, если данные введены то кнопка сохранить доступна
        var disableForm: Bool {
            categoryVM.nameCategorySave.isEmpty ||
            categoryVM.iconCategorySave.isEmpty ||
            categoryVM.colorCategorySave.isEmpty
        }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack {
                        ZStack {
                            Circle()
                                .fill(Color(categoryVM.colorCategorySave.isEmpty ? "swatch_articblue" : categoryVM.colorCategorySave))
                                .frame(width: 90, height: 90)
                                .shadow(radius: 10)
                                .padding()
                            Image(systemName: categoryVM.iconCategorySave.isEmpty ? "creditcard.fill" : categoryVM.iconCategorySave)
                                .font(Font.largeTitle)
                                .foregroundColor(Color.white)
                        }
                        
                        TextField("Category name", text: $categoryVM.nameCategorySave)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10.0)
                            .padding(.bottom)
                    }
                }
                
                Picker(selection: $typeTrancaction, label: Text("Transaction categories")) {
                    ForEach(types, id: \.rawValue) {
                        Text($0.rawValue).tag(Optional<TypeTrancaction>.some($0))
                    }
                }.pickerStyle(SegmentedPickerStyle())
                
                
                Section(header: Text("Color")) {
                    ColorSwatchView(selection: $categoryVM.colorCategorySave)
                }
                Section(header: Text("Icon")) {
                    SFSymbolsPicker(isPresented: $isPresentedIcon, icon: $categoryVM.iconCategorySave, category: .category, axis: .vertical, haptic: true).frame(height: 300)
                }
                
                
            }.dismissingKeyboard()
            
            .navigationTitle(categoryVM.categoryItem == nil ? "New category" : "Edit")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        if typeTrancaction == .expenses {
                            categoryVM.isExpensesCategorySave = false
                        }
                        if typeTrancaction == .income {
                            categoryVM.isExpensesCategorySave = true
                        }
                        
                        categoryVM.createCategory(context: viewContext)
                        self.isNewCategory.toggle()
                    }) {
                        Text(categoryVM.categoryItem == nil ? "Save" : "Update").bold()
                    }.disabled(disableForm)
                }
                
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button(action: {
                        self.isNewCategory.toggle()
                    }) {
                        Text("Cancel").bold()
                            .foregroundColor(Color.blue)
                    }
                }
            }
        }
    }
}


struct CategoryNewView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryNewView(isNewCategory: .constant(false))
    }
}
