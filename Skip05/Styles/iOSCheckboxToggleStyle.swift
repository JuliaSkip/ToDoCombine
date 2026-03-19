//
//  iOSCheckboxToggleStyle.swift
//  Skip05
//
//  Created by Скіп Юлія Ярославівна on 27.02.2026.
//

import SwiftUI

struct iOSCheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }, label: {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    .font(.title)
                configuration.label
            }
        })
    }
}
