//
//  ExpensesView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 20.03.2022.
//

import SwiftUI

struct ExpensesView: View {

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray)
                .frame(height: 80)
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "hand.thumbsdown.fill")
                        .padding(10)
                        .foregroundColor(Color.white)
                        .background(
                            Circle()
                                .fill()
                                .foregroundColor(.red)
                        )
                    Spacer()
                    Text("230")
                        .font(Font.title)
                        .bold()
                }
                Text("Expenses")
            }.padding()
        }
        
    }
}

struct ExpensesView_Previews: PreviewProvider {
    static var previews: some View {
        ExpensesView()
    }
}
