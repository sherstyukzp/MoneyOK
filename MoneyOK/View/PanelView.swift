//
//  PanelView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 11/08/2023.
//

import SwiftUI

struct PanelView: View {
    @State var colorIcon: Color = .blue
    @State var nameIcon: String = "calendar"
    @State var namePanel: String = "Today Expense"
    @State var cost: String = "1000"
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .foregroundColor(.yellow)
                .cornerRadius(10)
                
            VStack(alignment: .leading) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(colorIcon)
                            .frame(width: 36, height: 36)
                        Image(systemName: nameIcon)
                            .foregroundColor(Color.white)
                            .font(.headline)
                    }
                    Spacer()
                    Text(cost)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                Text(namePanel)
                    .foregroundColor(.gray)
                    .font(.headline)
                    .fontWeight(.bold)
                
            }.padding(10)
        }
    }
}

struct PanelView_Previews: PreviewProvider {
    static var previews: some View {
        PanelView()
    }
}
