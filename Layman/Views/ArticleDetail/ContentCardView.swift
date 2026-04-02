import SwiftUI

struct ContentCardView: View {
    let text: String
    let cardNumber: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Part \(cardNumber) of 3")
                .appFont(size: 11, weight: .semibold)
                .foregroundColor(AppTheme.accentOrange)
                .textCase(.uppercase)

            Text(text)
                .appFont(size: 16, weight: .regular)
                .foregroundColor(AppTheme.textPrimary)
                .lineSpacing(6)
                .lineLimit(5)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 160)
        .background(AppTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
    }
}
