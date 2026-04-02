import SwiftUI

struct SavedView: View {
    @StateObject private var viewModel = SavedViewModel()
    @State private var selectedArticle: Article?

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                // Header
                HStack {
                    Text("Saved")
                        .appFont(size: 28, weight: .bold, design: .serif)
                        .foregroundColor(AppTheme.textPrimary)
                    Spacer()
                    Button {} label: {
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
                .padding(.bottom, 12)

                // Search bar
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search saved articles...", text: $viewModel.searchText)
                        .appFont(size: 15, weight: .regular)
                }
                .padding(12)
                .background(Color(hex: "#F0E8E0"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 20)
                .padding(.bottom, 12)

                Divider()

                // Content
                if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else if viewModel.filtered.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "bookmark.slash")
                            .appFont(size: 40, weight: .light)
                            .foregroundColor(.gray.opacity(0.5))
                        Text(viewModel.searchText.isEmpty ? "No saved articles yet" : "No results found")
                            .appFont(size: 16, weight: .medium)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            ForEach(viewModel.filtered) { article in
                                Button {
                                    selectedArticle = article
                                } label: {
                                    TodaysPicksRowView(article: article)
                                }
                                .buttonStyle(.plain)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        Task { await viewModel.delete(articleID: article.id) }
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                                Divider().padding(.horizontal, 20)
                            }
                        }
                        .padding(.bottom, 20)
                    }
                }
            }
            .background(Color.white)
            .navigationBarHidden(true)
            .navigationDestination(item: $selectedArticle) { article in
                ArticleDetailView(article: article)
            }
            .task { await viewModel.load() }
        }
    }
}

#Preview {
    SavedView()
}
