import Foundation
import Combine

@MainActor
class NewsViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedCategory: NewsCategory = .technology

    private let service = NewsService()
    private var nextPage: String?

    func loadNews() async {
        isLoading = true
        errorMessage = nil
        nextPage = nil
        do {
            let response = try await service.fetchNews(category: selectedCategory)
            if response.status != "success" {
                errorMessage = response.message ?? "API error — check your NewsData.io key."
            } else {
                articles = response.results
                nextPage = response.nextPage
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func changeCategory(_ category: NewsCategory) async {
        selectedCategory = category
        await loadNews()
    }
}
