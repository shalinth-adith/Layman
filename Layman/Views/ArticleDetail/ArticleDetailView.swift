import SwiftUI

struct ArticleDetailView: View {
    let article: Article
    @StateObject private var viewModel = ArticleDetailViewModel()
    @Environment(\.dismiss) private var dismiss

    @EnvironmentObject private var tabBarState: TabBarState
    @State private var currentCard = 0
    @State private var showSafari = false
    @State private var showAskLayman = false

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {

                    // Top bar
                    HStack {
                        Button { dismiss() } label: {
                            Image(systemName: "chevron.left")
                                .appFont(size: 16, weight: .semibold)
                                .foregroundColor(AppTheme.textPrimary)
                                .padding(10)
                                .background(Color(hex: "#F0E8E0"))
                                .clipShape(Circle())
                        }

                        Spacer()

                        HStack(spacing: 12) {
                            // Link
                            Button {
                                if URL(string: article.link ?? "") != nil { showSafari = true }
                            } label: {
                                Image(systemName: "link")
                                    .topBarIcon()
                            }

                            // Bookmark
                            Button { Task { await viewModel.toggleBookmark(article: article) } } label: {
                                Image(systemName: viewModel.isBookmarked ? "bookmark.fill" : "bookmark")
                                    .foregroundColor(viewModel.isBookmarked ? AppTheme.accentOrange : AppTheme.textPrimary)
                                    .appFont(size: 16, weight: .semibold)
                                    .padding(10)
                                    .background(Color(hex: "#F0E8E0"))
                                    .clipShape(Circle())
                            }

                            // Share
                            Button {
                                let av = UIActivityViewController(activityItems: [article.link ?? ""], applicationActivities: nil)
                                UIApplication.shared.connectedScenes
                                    .compactMap { $0 as? UIWindowScene }
                                    .first?.windows.first?
                                    .rootViewController?.present(av, animated: true)
                            } label: {
                                Image(systemName: "square.and.arrow.up")
                                    .topBarIcon()
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 16)

                    // Headline — exactly 2 lines
                    Text(article.title)
                        .appFont(size: 22, weight: .bold)
                        .foregroundColor(AppTheme.textPrimary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 16)

                    // Full-width article photo
                    AsyncImage(url: URL(string: article.imageURL ?? "")) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Rectangle().fill(Color(hex: "#E0D0C0"))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 240)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)

                    // Content cards
                    if viewModel.isLoading {
                        VStack(spacing: 12) {
                            ForEach(0..<3, id: \.self) { _ in
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(AppTheme.cardBackground)
                                    .frame(height: 180)
                                    .overlay(ProgressView())
                            }
                        }
                        .padding(.horizontal, 20)
                    } else {
                        VStack(spacing: 10) {
                            TabView(selection: $currentCard) {
                                ForEach(Array(viewModel.contentCards.enumerated()), id: \.offset) { index, card in
                                    ContentCardView(text: card, cardNumber: index + 1)
                                        .padding(.horizontal, 20)
                                        .tag(index)
                                }
                            }
                            .tabViewStyle(.page(indexDisplayMode: .never))
                            .frame(height: 180)

                            // Page dots
                            HStack(spacing: 6) {
                                ForEach(0..<viewModel.contentCards.count, id: \.self) { i in
                                    Capsule()
                                        .fill(i == currentCard ? AppTheme.accentOrange : Color(hex: "#D0C0B0"))
                                        .frame(width: i == currentCard ? 20 : 6, height: 6)
                                        .animation(.easeInOut(duration: 0.2), value: currentCard)
                                }
                            }
                            .padding(.top, 4)
                        }
                    }

                    Spacer().frame(height: 100)
                }
            }

            // Ask Layman fixed button
            Button { showAskLayman = true } label: {
                HStack(spacing: 8) {
                    Image(systemName: "bubble.left.fill")
                        .appFont(size: 16, weight: .semibold)
                    Text("Ask Layman")
                        .appFont(size: 16, weight: .semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(AppTheme.accentOrange)
                .clipShape(Capsule())
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
            .background(
                LinearGradient(
                    colors: [Color.white.opacity(0), Color.white],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 100)
                .allowsHitTesting(false)
            )
        }
        .navigationBarHidden(true)
        .onAppear { tabBarState.isHidden = true }
        .onDisappear { tabBarState.isHidden = false }
        .task { await viewModel.loadContent(for: article) }
        .sheet(isPresented: $showSafari) {
            if let url = URL(string: article.link ?? "") {
                SafariView(url: url)
                    .ignoresSafeArea()
            }
        }
        .sheet(isPresented: $showAskLayman) {
            AskLaymanView(article: article)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - Helper
private extension Image {
    func topBarIcon() -> some View {
        self
            .appFont(size: 16, weight: .semibold)
            .foregroundColor(AppTheme.textPrimary)
            .padding(10)
            .background(Color(hex: "#F0E8E0"))
            .clipShape(Circle())
    }
}
