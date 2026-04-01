import Foundation

struct Article: Identifiable, Codable {
    let id: String
    let title: String
    let description: String?
    let content: String?
    let imageURL: String?
    let pubDate: String
    let sourceID: String?
    let link: String
    let category: [String]?

    enum CodingKeys: String, CodingKey {
        case id          = "article_id"
        case title
        case description
        case content
        case imageURL    = "image_url"
        case pubDate
        case sourceID    = "source_id"
        case link
        case category
    }
}

struct NewsResponse: Decodable {
    let status: String
    let results: [Article]
    let nextPage: String?
}
