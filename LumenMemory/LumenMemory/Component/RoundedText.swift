import SwiftUI

struct RoundedText: View {

    var text: String

    var body: some View {
        Text(text)
            .ctaFont()
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .stroke(lineWidth: 6)
            }
    }
}

#Preview {
    RoundedText(text: "Button")
}
