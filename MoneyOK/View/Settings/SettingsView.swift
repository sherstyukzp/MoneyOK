//
//  SettingsView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 09.02.2022.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section (header: HeaderSettingView(imageIcon: "slider.horizontal.3", text: "Management")) {
                    NavigationLink("Category Management") {
                        CategotyView()
                    }
                    NavigationLink("Transaction Management") {
                        TransactionAllListView()
                    }
                }
                
                
                Section(header: HeaderSettingView(imageIcon: "rosette", text: "Other applications"),
                        footer: Text("We also have other applications that you have to enjoy")) {
                    Link("PomodOK", destination: URL(string: "https://apps.apple.com/us/app/pomodok/id1553058624")!).foregroundColor(Color.blue)
                    Link("CoordinateConverter", destination: URL(string: "https://apps.apple.com/us/app/coordinateconverter/id1604393688")!).foregroundColor(Color.blue)
                }
                
                Section(header: HeaderSettingView(imageIcon: "text.bubble", text: "Communication with us"),
                        footer: Text("Click on the button and select a convenient way to communicate with us.")) {
                    HStack {
                        NavigationLink(destination: SendUseView()) {
                            Text("Write to us")
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Settings"))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
