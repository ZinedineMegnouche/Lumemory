import SwiftUI

struct ShadowLarge: ViewModifier {
    
    @ViewBuilder
    func body(content: Content) -> some View {
        content.shadow(color: .black,
                       radius: 8, x: 0, y: 4)
    }
}

extension View {
    
    func shadowLarge() -> some View {
        self.modifier(ShadowLarge())
    }
}
