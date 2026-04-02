import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = NewsViewModel()
    @State private var selectedArticle: Article?

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {

                    // Header
                    HStack {
                        Text("Layman")
                            .appFont(size: 28, weight: .bold, design: .serif)
                            .foregroundColor(AppTheme.textPrimary)
                        Spacer()
                        Button {
                            // search action
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .appFont(size: 16, weight: .semibold)
                                .foregroundColor(AppTheme.textPrimary)
                                .padding(10)
                                .background(Color(hex: "#F0E8E0"))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 14)

                    // Category chips
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(NewsCategory.allCases) { category in
                                Button {
                                    Task { await viewModel.changeCategory(category) }
                                } label: {
                                    Text(category.rawValue)
                                        .appFont(size: 13, weight: .medium)
                                        .foregroundColor(viewModel.selectedCategory == category ? .white : AppTheme.textPrimary)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(
                                            Capsule()
                                                .fill(viewModel.selectedCategory == category
                                                      ? AppTheme.accentOrange
                                                      : Color(hex: "#F0E8E0"))
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 16)

                    // Carousel
                    if viewModel.isLoading {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(hex: "#E0D0C0"))
                            .frame(height: 320)
                            .padding(.horizontal, 20)
                            .overlay(ProgressView())
                    } else if let error = viewModel.errorMessage {
                        Text("Error: \(error)")
                            .appFont(size: 13, weight: .regular)
                            .foregroundColor(.red)
                            .padding()
                    } else if viewModel.articles.isEmpty {
                        Text("No articles found. Check your API key.")
                            .appFont(size: 13, weight: .regular)
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        CarouselView(articles: viewModel.articles) { article in
                            selectedArticle = article
                        }
                    }

                    // Today's Picks header
                    HStack {
                        Text("Today's Picks")
                            .appFont(size: 20, weight: .bold)
                            .foregroundColor(AppTheme.textPrimary)
                        Spacer()
                        Button("View All") {}
                            .appFont(size: 14, weight: .medium)
                            .foregroundColor(AppTheme.accentOrange)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 22)
                    .padding(.bottom, 8)

                    // Today's Picks list
                    ForEach(viewModel.articles.dropFirst(5)) { article in
                        Button {
                            selectedArticle = article
                        } label: {
                            TodaysPicksRowView(article: article)
                        }
                        .buttonStyle(.plain)
                    }

                    Spacer().frame(height: 20)
                }
            }
            .background(Color.white)
            .navigationBarHidden(true)
            .navigationDestination(item: $selectedArticle) { article in
                ArticleDetailView(article: article)
            }
            .task { await viewModel.loadNews() }
        }
    }
}

#Preview {
    HomeView()
}
