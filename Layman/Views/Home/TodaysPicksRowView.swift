import SwiftUI

struct TodaysPicksRowView: View {
    let article: Article

    var body: some View {
        HStack(spacing: 12) {
            // Thumbnail
            AsyncImage(url: URL(string: article.imageURL ?? "")) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Rectangle().fill(Color(hex: "#E0D0C0"))
            }
            .frame(width: 90, height: 90)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            // Text
            VStack(alignment: .leading, spacing: 6) {
                Text(String(article.title.prefix(52)))
                    .appFont(size: 14, weight: .semibold)
                    .foregroundColor(AppTheme.textPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                Spacer()

                HStack(spacing: 4) {
                    if let source = article.sourceID {
                        Text(source)
                            .appFont(size: 12, weight: .medium)
                            .foregroundColor(AppTheme.accentOrange)
                    }
                    Text("·")
                        .foregroundColor(.gray)
                    Text(String((article.pubDate ?? "").prefix(10)))
                        .appFont(size: 12, weight: .regular)
                        .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 6)
        }
        .padding(12)
        .background(AppTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
        .padding(.horizontal, 16)
        .padding(.vertical, 5)
    }
}
