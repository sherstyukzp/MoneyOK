//
//  NewTransactionView.swift
//  MoneyOK-iOS
//
//  Created by Ярослав Шерстюк on 31.01.2022.
//

import SwiftUI

struct NewTransactionView: View {
    
    let types = Array(TypeTrancaction.allCases)
    @State var typeTrancaction: TypeTrancaction? = .costs
    @State var sumTransaction: String = ""
    
    @Binding var showAddTransaction: Bool
    
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
                    Text("Время:")
                    Text("Заметки")
                }
            
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
                    .frame(width: 250, height: 40)
                
                }.buttonStyle(.borderedProminent)
                  
                }
                .padding(6)
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.secondarySystemBackground))
                    
            }
            
            
            
                .navigationTitle("Новая транзакция")
                .toolbar{
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
