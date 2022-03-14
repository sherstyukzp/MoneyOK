//
//  SendUseView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 14.03.2022.
//

import SwiftUI

struct SendUseView: View {
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    
    // MARK: - UI
    var body: some View {
        Form {
            Section (header: Text("Select a method"), footer: Text("Choose one of the ways to communicate with us. \n We will be happy to receive a message from you.")) {
                Link("Telegram", destination: URL(string: "https://t.me/YaroslavSherstyuk")!)
                Link("Twetter", destination: URL(string: "https://twitter.com/MoneyOKApp")!)
            }
            .navigationBarTitle(Text("Write to us"), displayMode: .large)
        }
    }
}

struct SendUseView_Previews: PreviewProvider {
    static var previews: some View {
        SendUseView()
    }
}

