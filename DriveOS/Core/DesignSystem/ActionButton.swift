//
//  ActionButton.swift
//  DriveOS
//
//  Created by Hemang J Solanki on 04/06/26.
//

import SwiftUI

struct ActionButton: View {
    var title: String
    var icon: String
    var isActive: Bool = false
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            action()
        }) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(isActive ? Theme.primary : Theme.surfaceHighlight)
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(isActive ? .white : Theme.textPrimary)
                }
                
                Text(title)
                    .font(.caption.weight(.medium))
                    .foregroundColor(Theme.textSecondary)
            }
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.interactiveSpring(response: 0.2, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

#Preview {
    ZStack {
        Theme.background.ignoresSafeArea()
        HStack(spacing: 30) {
            ActionButton(title: "Lock", icon: "lock.fill", isActive: true) {}
            ActionButton(title: "Climate", icon: "fanblades.fill") {}
            ActionButton(title: "Trunk", icon: "car.top.door.front.open.fill") {}
        }
    }
}
