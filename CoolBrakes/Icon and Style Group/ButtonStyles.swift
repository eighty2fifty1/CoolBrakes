//
//  ButtonStyles.swift
//  CoolBrakes
//
//  Created by James Ford on 11/1/21.
//

import Foundation
import SwiftUI

struct StandardButton: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(isEnabled ? Color.buttonEnabled : Color.buttonDisabled)
            .foregroundColor(isEnabled ? Color.white : Color.red)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            //.animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
