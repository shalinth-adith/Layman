import Foundation
import Combine

@MainActor
class SavedViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var searchText = ""
    @Published var isLoading = false

    var filtered: [Article] {
        if searchText.isEmpty { return articles }
        return articles.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }

    func load() async {
        isLoading = true
        do {
            articles = try await SupabaseService.shared.fetchSavedArticles()
        } catch {
            print("Failed to load saved articles: \(error)")
        }
        isLoading = false
    }

    func delete(articleID: String) async {
        do {
            try await SupabaseService.shared.deleteArticle(articleID: articleID)
            articles.removeAll { $0.id == articleID }
        } catch {
            print("Failed to delete: \(error)")
        }
    }
}
