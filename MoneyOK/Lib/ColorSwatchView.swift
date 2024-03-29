//
//  ColorSwatchView.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 25.01.2022.
//

import SwiftUI

struct ColorSwatchView: View {

    @Binding var selection: String

    var body: some View {

        let swatches = [
            "swatch_chestnutrose",
            "swatch_japonica",
            "swatch_rawsienna",
            "swatch_tussock",
            "swatch_asparagus",
            "swatch_patina",
            "swatch_bermudagray",
            "swatch_shipcove",
            "swatch_articblue",
            "swatch_wisteria",
            "swatch_mulberry",
            "swatch_charm"
        ]

        let columns = [
            GridItem(.adaptive(minimum: 40))
        ]

        LazyVGrid(columns: columns, spacing: 2) {
            ForEach(swatches, id: \.self){ swatch in
                ZStack {
                    Circle()
                        .fill(Color(swatch))
                        .frame(width: 40, height: 40)
                        .onTapGesture(perform: {
                            selection = swatch
                        })
                        .padding(5)

                    if selection == swatch {
                        Circle()
                            .stroke(Color(swatch), lineWidth: 4)
                            .frame(width: 50, height: 50)
                    }
                }
            }
        }
        
    }
}

struct ColorSwatchView_Previews: PreviewProvider {
    static var previews: some View {
        ColorSwatchView(selection: .constant("swatch_shipcove"))
    }
}


