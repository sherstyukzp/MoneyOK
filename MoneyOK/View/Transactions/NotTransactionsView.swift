//
//  NotTransactionsView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 24.09.2022.
//

import SwiftUI

struct NotTransactionsView: View {
    var body: some View {
        VStack {
            Image(systemName: "tray.2.fill")
                .font(.system(size: 80))
                .foregroundColor(.gray)
            Text("No transactions!")
                .font(.title3)
                .fontWeight(.bold)
                .padding()
            Text("To add a new transaction, click on the ''Transaction'' button.")
                .font(.subheadline)
                .foregroundColor(Color.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30.0)
        }
    }
}

struct NotTransactionsView_Previews: PreviewProvider {
    static var previews: some View {
        NotTransactionsView()
    }
}
