//
//  AccountView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 21.01.2022.
//

import SwiftUI

struct AccountView: View {
    @State var colorAccount: String
    @State var iconAccount: String
    @State var nameAccount: String
    @State var balance: Double
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(Color(colorAccount ))
                    .frame(width: 32, height: 32)
                Image(systemName: iconAccount )
                    .foregroundColor(Color.white)
                    .font(Font.footnote)
            }
            
            VStack(alignment: .leading) {
                Text("\(nameAccount)").bold()
                Text("Баланс: \(balance)").font(Font.footnote).foregroundColor(Color.gray)
            }
            
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(colorAccount: "swatch_asparagus", iconAccount: "creditcard", nameAccount: "MonoBank", balance: 99.9)
            
    }
}
