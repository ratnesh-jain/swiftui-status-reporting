//
//  StatusButtonStyle.swift
//  swiftui-status-reporting
//
//  Created by Ratnesh Jain on 01/02/25.
//

import SwiftUI

/// A Special Button Style that can intercept the button action.
struct StatusButtonStyle: ButtonStyle {
    var action: () -> Void
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .padding(.horizontal, 4)
            .background(.quaternary, in: Capsule())
            .opacity(configuration.isPressed ? 0.5 : 1)
            .onChange(of: configuration.isPressed) { oldValue, newValue in
                if oldValue == true && newValue == false {
                    action()
                }
            }
    }
}
