import Foundation
import Combine

@MainActor
class ArticleDetailViewModel: ObservableObject {
    @Published var contentCards: [String] = []
    @Published var isLoading = false
    @Published var isBookmarked = false

    func loadContent(for article: Article) async {
        guard contentCards.isEmpty else { return }
        isLoading = true
        do {
            let content = article.content ?? article.description ?? article.title
            contentCards = try await GroqService.shared.simplifyArticle(
                title: article.title,
                content: content
            )
        } catch {
            contentCards = [
                article.description ?? article.title,
                "Tap 'Ask Layman' to learn more about this story.",
                "Stay informed with Layman — news made simple."
            ]
        }
        isLoading = false
    }

    func toggleBookmark(article: Article) async {
        isBookmarked.toggle()
        do {
            if isBookmarked {
                try await SupabaseService.shared.saveArticle(article)
            } else {
                try await SupabaseService.shared.deleteArticle(articleID: article.id)
            }
        } catch {
            print("Bookmark error: \(error)")
        }
    }
}
