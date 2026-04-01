import Foundation

class NewsService {
    private let apiKey = Bundle.main.infoDictionary?["NEWS_DATA_API_KEY"] as? String ?? ""
    private let baseURL = "https://newsdata.io/api/1/news"

    func fetchNews(category: NewsCategory, nextPage: String? = nil) async throws -> NewsResponse {
        var components = URLComponents(string: baseURL)!
        var queryItems = [
            URLQueryItem(name: "apikey",   value: apiKey),
            URLQueryItem(name: "language", value: "en"),
            URLQueryItem(name: "category", value: category.apiValue),
            URLQueryItem(name: "size",     value: "10")
        ]
        if let nextPage {
            queryItems.append(URLQueryItem(name: "page", value: nextPage))
        }
        components.queryItems = queryItems

        let (data, _) = try await URLSession.shared.data(from: components.url!)
        return try JSONDecoder().decode(NewsResponse.self, from: data)
    }
}
