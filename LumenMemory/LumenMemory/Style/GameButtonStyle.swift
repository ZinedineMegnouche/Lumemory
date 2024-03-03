import SwiftUI
struct GameButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .foregroundColor(configuration.isPressed ? Color.white.opacity(0.5) : Color.white)
            .animation(.easeIn, value: 0.2)
            
    }
}
