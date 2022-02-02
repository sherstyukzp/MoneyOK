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
            
            VStack {
                Picker(selection: $typeTrancaction, label: Text("Системы координат")) {
                    ForEach(types, id: \.rawValue) {
                        Text($0.rawValue).tag(Optional<TypeTrancaction>.some($0))
                    }
                }.pickerStyle(SegmentedPickerStyle())
                // Сумма
                VStack(alignment: .leading) {
                    Text("Сумма")
                        .font(.system(size: 28, weight: .bold))
                    
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
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10.0)
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Счёт")
                        .font(.system(size: 28, weight: .bold))
                    
                    NavigationLink(destination: AccountsListShowView()) {

                        VStack {
                                Text("Счёт")
                                    .bold()
                                    .foregroundColor(Color.gray)
                                
                                Text("Нажмите чтобы выбрать")
                                .font(Font.footnote)
                                .foregroundColor(Color.gray)
                            }
                        .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10.0)

                    }
                    
                    VStack {
                            Text("Категория")
                                .bold()
                                .foregroundColor(Color.gray)
                            
                            Text("Нажмите чтобы выбрать")
                            .font(Font.footnote)
                            .foregroundColor(Color.gray)
                        }
                    .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10.0)
                }
                
                
                
                Button {
                    print("Session is cancelled")
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill").font(.system(size: 22, weight: .bold))
                        Text("Добавить").bold()
                    }
                    .frame(width: 250, height: 40)
                    
                    
                }.buttonStyle(.borderedProminent)
                
                
                
                Spacer()
            }.padding()
            
                .navigationTitle("Новая транзакция")
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
