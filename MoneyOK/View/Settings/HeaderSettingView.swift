//
//  HeaderSettingView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 14.03.2022.
//

import SwiftUI



struct HeaderSettingView: View {
    @State var imageIcon: String = ""
    @State var text: String = ""
    
    var body: some View {
        HStack {
            Image(systemName: imageIcon)
            Text(text)
        }
    }
}

struct HaederSettingView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderSettingView()
    }
}
