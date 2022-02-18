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
                        
                        
                        TextField("Имя категории", text: $categoryVM.nameCategorySave)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10.0)
                            .padding(.bottom)
                    }
                }
                Section(header: Text("Цвет")) {
                    
                    ColorSwatchView(selection: $categoryVM.colorCategorySave)
                }
                Section(header: Text("Иконка")) {
                    SFSymbolsPicker(isPresented: $isPresentedIcon, icon: $categoryVM.iconCategorySave, category: .people, axis: .vertical, haptic: true).frame(height: 300)
                }
                
                
            }.dismissingKeyboard()
            
            .navigationTitle(categoryVM.categoryItem == nil ? "Новая категория" : "Редактировать")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        categoryVM.createCategory(context: viewContext)
                        self.isNewCategory.toggle()
                    }) {
                        Text(categoryVM.categoryItem == nil ? "Сохранить" : "Обновить").bold()
                    }.disabled(disableForm)
                }
                
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button(action: {
                        self.isNewCategory.toggle()
                    }) {
                        Text("Отмена").bold()
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
