//
//  ButtonStyles.swift
//  CoolBrakes
//
//  Created by James Ford on 11/1/21.
//

import Foundation
import SwiftUI

struct StandardButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            //.animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
