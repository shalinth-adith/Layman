import SwiftUI

enum AppTheme {
    static let accentOrange   = Color(hex: "#E8593C")
    static let gradientStart  = Color(hex: "#F5C5A3")
    static let gradientEnd    = Color(hex: "#E8875A")
    static let cardBackground = Color(hex: "#FAF7F2")
    static let textPrimary    = Color(hex: "#1A1A1A")

    static let warmGradient = LinearGradient(
        colors: [gradientStart, gradientEnd],
        startPoint: .top,
        endPoint: .bottom
    )
}

struct AppFontModifier: ViewModifier {
    let font: SwiftUI.Font
    func body(content: Content) -> some View {
        content.font(font)
    }
}

extension View {
    func appFont(size: CGFloat, weight: SwiftUI.Font.Weight = .regular, design: SwiftUI.Font.Design = .default) -> some View {
        modifier(AppFontModifier(font: SwiftUI.Font.system(size: size, weight: weight, design: design)))
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8)  & 0xFF) / 255
        let b = Double(int         & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
