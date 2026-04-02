import Foundation
import Supabase

class SupabaseService {
    static let shared = SupabaseService()

    let client: SupabaseClient

    private init() {
        let host = (Bundle.main.infoDictionary?["SUPABASE_HOST"] as? String ?? "").trimmingCharacters(in: .whitespaces)
        let key = (Bundle.main.infoDictionary?["SUPABASE_ANON_KEY"] as? String ?? "").trimmingCharacters(in: .whitespaces)
        let urlString = "https://\(host)"
        print("Supabase URL: \(urlString)")
        let url = URL(string: urlString) ?? URL(string: "https://placeholder.supabase.co")!
        client = SupabaseClient(supabaseURL: url, supabaseKey: key)
    }

    // MARK: - Auth
    func signUp(email: String, password: String) async throws {
        try await client.auth.signUp(email: email, password: password)
    }

    func signIn(email: String, password: String) async throws {
        try await client.auth.signIn(email: email, password: password)
    }

    func signOut() async throws {
        try await client.auth.signOut()
    }

    var currentUser: User? {
        client.auth.currentUser
    }

    // MARK: - Saved Articles
    func saveArticle(_ article: Article) async throws {
        let userID = currentUser?.id.uuidString ?? "anonymous"
        let row = SavedArticleRow(
            userID: userID,
            articleID: article.id,
            title: article.title,
            description: article.description,
            imageURL: article.imageURL,
            link: article.link,
            sourceID: article.sourceID,
            pubDate: article.pubDate
        )
        try await client.from("saved_articles").insert(row).execute()
    }

    func fetchSavedArticles() async throws -> [Article] {
        let rows: [SavedArticleRow] = try await client
            .from("saved_articles")
            .select()
            .order("created_at", ascending: false)
            .execute()
            .value
        return rows.map { $0.toArticle() }
    }

    func deleteArticle(articleID: String) async throws {
        let userID = currentUser?.id.uuidString ?? "anonymous"
        try await client.from("saved_articles")
            .delete()
            .eq("article_id", value: articleID)
            .eq("user_id", value: userID)
            .execute()
    }

    func isArticleSaved(articleID: String) async -> Bool {
        let userID = currentUser?.id.uuidString ?? "anonymous"
        let result = try? await client.from("saved_articles")
            .select()
            .eq("article_id", value: articleID)
            .eq("user_id", value: userID)
            .execute()
            .value as [SavedArticleRow]
        return !(result?.isEmpty ?? true)
    }
}

// MARK: - Row Model
struct SavedArticleRow: Codable {
    let userID: String
    let articleID: String
    let title: String
    let description: String?
    let imageURL: String?
    let link: String?
    let sourceID: String?
    let pubDate: String?

    enum CodingKeys: String, CodingKey {
        case userID      = "user_id"
        case articleID   = "article_id"
        case title
        case description
        case imageURL    = "image_url"
        case link
        case sourceID    = "source_id"
        case pubDate     = "pub_date"
    }

    func toArticle() -> Article {
        Article(
            id: articleID,
            title: title,
            description: description,
            content: nil,
            imageURL: imageURL,
            pubDate: pubDate,
            sourceID: sourceID,
            link: link,
            category: nil
        )
    }
}
