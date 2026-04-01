import Foundation

enum NewsCategory: String, CaseIterable, Identifiable {
    case business   = "Business"
    case technology = "Technology"
    case startups   = "Startups"

    var id: String { rawValue }

    var apiValue: String {
        switch self {
        case .business:   return "business"
        case .technology: return "technology"
        case .startups:   return "technology"
        }
    }
}
