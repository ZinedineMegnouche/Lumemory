import Foundation
import SwiftUI

struct LumenMemoryBg: ViewModifier {

    func body(content: Content) -> some View {
        content.background(Image("bg")
            .resizable()
            .scaledToFill())
        .ignoresSafeArea()
    }
}

extension View {

    func lumenMemoryBG() -> some View {
        modifier(LumenMemoryBg())
    }
}
