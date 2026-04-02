import SwiftUI

struct CarouselView: View {
    let articles: [Article]
    var onTap: (Article) -> Void

    @State private var currentIndex = 0
    private var carouselArticles: [Article] { Array(articles.prefix(5)) }
    private let cardWidth = UIScreen.main.bounds.width - 40

    var body: some View {
        VStack(spacing: 10) {
            TabView(selection: $currentIndex) {
                ForEach(Array(carouselArticles.enumerated()), id: \.offset) { index, article in
                    CarouselCardView(article: article, width: cardWidth)
                        .tag(index)
                        .onTapGesture { onTap(article) }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 300)

            // Page dots
            HStack(spacing: 6) {
                ForEach(0..<carouselArticles.count, id: \.self) { index in
                    Capsule()
                        .fill(index == currentIndex ? AppTheme.accentOrange : Color(hex: "#D0C0B0"))
                        .frame(width: index == currentIndex ? 20 : 6, height: 6)
                        .animation(.easeInOut(duration: 0.2), value: currentIndex)
                }
            }
        }
    }
}

struct CarouselCardView: View {
    let article: Article
    let width: CGFloat

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Image
            AsyncImage(url: URL(string: article.imageURL ?? "")) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Rectangle().fill(Color(hex: "#E0D0C0"))
            }
            .frame(width: width, height: 280)
            .clipped()

            // Bottom gradient
            LinearGradient(
                stops: [
                    .init(color: Color.black.opacity(0.85), location: 0.0),
                    .init(color: Color.black.opacity(0.4), location: 0.5),
                    .init(color: Color.clear, location: 1.0)
                ],
                startPoint: .bottom,
                endPoint: .top
            )

            // Headline
            VStack(alignment: .leading, spacing: 4) {
                Text(String(article.title.prefix(52)))
                    .appFont(size: 17, weight: .bold)
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                if let source = article.sourceID {
                    Text(source.uppercased())
                        .appFont(size: 11, weight: .semibold)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .frame(width: width, height: 280)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 4)
    }
}
