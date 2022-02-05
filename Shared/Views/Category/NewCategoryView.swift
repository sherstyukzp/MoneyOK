//
//  NewCategoryView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 05.02.2022.
//

import SwiftUI

struct NewCategoryView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var categoryCostsListVM: CategoryCostsViewModel
    
    @Binding var showAddCategory: Bool
    @State private var isPresentedIcon: Bool = true
    

    
    // MARK: - Проверка введённых данных, если данные введены то кнопка сохранить доступна
        var disableForm: Bool {
            categoryCostsListVM.nameCategoryCostsSave.isEmpty ||
            categoryCostsListVM.iconCategoryCostsSave.isEmpty ||
            categoryCostsListVM.colorCategoryCostsSave.isEmpty
        }
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack {
                        ZStack {
                            Circle()
                                .fill(Color(categoryCostsListVM.colorCategoryCostsSave.isEmpty ? "swatch_articblue" : categoryCostsListVM.colorCategoryCostsSave))
                                .frame(width: 90, height: 90)
                                .shadow(radius: 10)
                                .padding()
                            Image(systemName: categoryCostsListVM.iconCategoryCostsSave.isEmpty ? "creditcard.fill" : categoryCostsListVM.iconCategoryCostsSave)
                                .font(Font.largeTitle)
                                .foregroundColor(Color.white)
                        }
                        
                        
                        TextField("Имя категории", text: $categoryCostsListVM.nameCategoryCostsSave)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10.0)
                            .padding(.bottom)
                    }
                }
                Section(header: Text("Цвет")) {
                    
                    ColorSwatchView(selection: $categoryCostsListVM.colorCategoryCostsSave)
                }
                Section(header: Text("Иконка")) {
                    SFSymbolsPicker(isPresented: $isPresentedIcon, icon: $categoryCostsListVM.iconCategoryCostsSave, category: .people, axis: .vertical, haptic: true).frame(height: 300)
                }
                
                
            }.dismissingKeyboard()
            
                .navigationTitle(categoryCostsListVM.categoryCostsListItem == nil ? "Новая" : "Редактировать")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(leading: Button("Отмена", action: {
                    self.showAddCategory.toggle()
                }), trailing: Button(action: {
                    categoryCostsListVM.createCategoryCosts(context: viewContext)
                    self.showAddCategory.toggle()
                }) {
                    Text(categoryCostsListVM.categoryCostsListItem == nil ? "Сохранить" : "Обновить")
                }.disabled(disableForm)
                )
        }
        
    }
}

struct NewCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        NewCategoryView(showAddCategory: .constant(false))
    }
}
