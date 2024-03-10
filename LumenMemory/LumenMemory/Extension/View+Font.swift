import SwiftUI

struct TitleFont: ViewModifier {

    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .font(.custom("Audiowide-Regular", size: 60))
            .foregroundStyle(.white)
            .bold()
    }
}

extension View {

    func titleFont() -> some View {
        self.modifier(TitleFont())
    }
}

struct Title2Font: ViewModifier {

    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .font(.custom("Audiowide-Regular", size: 40))
            .foregroundStyle(.white)
            .bold()
    }
}

extension View {

    func title2Font() -> some View {
        self.modifier(Title2Font())
    }
}

struct Title3Font: ViewModifier {

    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .font(.custom("Audiowide-Regular", size: 24))
            .foregroundStyle(.white)
            .bold()
    }
}

extension View {

    func title3Font() -> some View {
        self.modifier(Title3Font())
    }
}

struct CTAFont: ViewModifier {

    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .font(.custom("Audiowide-Regular", size: 30))
            .bold()
    }
}

extension View {

    func ctaFont() -> some View {
        self.modifier(CTAFont())
    }
}

struct SmallCTAFont: ViewModifier {

    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .font(.custom("Audiowide-Regular", size: 16))
    }
}

extension View {

    func smallCtaFont() -> some View {
        self.modifier(SmallCTAFont())
    }
}

struct BodyFont: ViewModifier {

    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .font(.custom("Audiowide-Regular", size: 18))
    }
}

extension View {

    func bodyFont() -> some View {
        self.modifier(BodyFont())
    }
}

struct CellFont: ViewModifier {

    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .font(.system(size: 18))
    }
}

extension View {

    func cellFont() -> some View {
        self.modifier(CellFont())
    }
}
