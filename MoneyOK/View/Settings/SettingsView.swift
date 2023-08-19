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
                Section {
                    NavigationLink("Category Management") {
                        CategotyView()
                    }
                    NavigationLink("Transaction Management") {
                        TransactionAllListView()
                    }
                } header: {
                    HStack {
                        Image(systemName: "slider.horizontal.3")
                        Text("Management")
                    }
                }
                Section {
                    Link("PomodOK", destination: URL(string: "https://apps.apple.com/us/app/pomodok/id1553058624")!).foregroundColor(Color.blue)
                    Link("CoordinateConverter", destination: URL(string: "https://apps.apple.com/us/app/coordinateconverter/id1604393688")!).foregroundColor(Color.blue)
                } header: {
                    HStack {
                        Image(systemName: "rosette")
                        Text("Other applications")
                    }
                } footer: {
                    Text("We also have other applications that you have to enjoy")
                }
                Section {
                    NavigationLink(destination: SendUseView()) {
                        Text("Write to us")
                    }
                } header: {
                    HStack {
                        Image(systemName: "text.bubble")
                        Text("Communication with us")
                    }
                } footer: {
                    Text("Click on the button and select a convenient way to communicate with us.")
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
