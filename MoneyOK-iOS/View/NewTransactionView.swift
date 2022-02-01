//
//  NewTransactionView.swift
//  MoneyOK-iOS
//
//  Created by Ярослав Шерстюк on 31.01.2022.
//

import SwiftUI

struct NewTransactionView: View {
    var body: some View {
        Button(action: {
            
        }, label: {
            Image(systemName: "plus.circle.fill")
            Text("Добавить")
        })
        .padding(12)
        .background(Color(UIColor.blue))
        .foregroundColor(.white)
        .cornerRadius(8)
    }
}

struct NewTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        NewTransactionView()
    }
}
