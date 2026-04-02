import Foundation

class GroqService {
    static let shared = GroqService()
    private let apiKey = (Bundle.main.infoDictionary?["GROQ_API_KEY"] as? String ?? "").trimmingCharacters(in: .whitespaces)
    private let endpoint = "https://api.groq.com/openai/v1/chat/completions"

    private init() {}

    func simplifyArticle(title: String, content: String) async throws -> [String] {
        let prompt = """
        You are Layman, an AI that explains news in simple everyday language.

        Summarize this article in exactly 3 parts. Each part must be exactly 28-35 words, written in casual, simple language anyone can understand. No jargon.

        Return ONLY a JSON array with exactly 3 strings, like: ["part1", "part2", "part3"]

        Article Title: \(title)
        Article Content: \(content.prefix(1500))
        """

        let body: [String: Any] = [
            "model": "llama3-8b-8192",
            "messages": [
                ["role": "user", "content": prompt]
            ],
            "temperature": 0.5,
            "max_tokens": 300
        ]

        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(GroqResponse.self, from: data)
        let text = response.choices.first?.message.content ?? ""

        // Parse JSON array from response
        if let jsonData = text.data(using: .utf8),
           let parts = try? JSONDecoder().decode([String].self, from: jsonData),
           parts.count == 3 {
            return parts
        }

        // Fallback: split by newline
        let parts = text.components(separatedBy: "\n").filter { !$0.isEmpty }
        if parts.count >= 3 { return Array(parts.prefix(3)) }

        return [text, "", ""]
    }

    func generateQuestions(title: String, content: String) async throws -> [String] {
        let prompt = """
        Based on this article, generate exactly 3 short questions a reader might want to ask.
        Each question should be under 8 words, casual tone.
        Return ONLY a JSON array: ["q1", "q2", "q3"]

        Title: \(title)
        """

        let body: [String: Any] = [
            "model": "llama3-8b-8192",
            "messages": [["role": "user", "content": prompt]],
            "temperature": 0.7,
            "max_tokens": 150
        ]

        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(GroqResponse.self, from: data)
        let text = response.choices.first?.message.content ?? ""

        if let jsonData = text.data(using: .utf8),
           let questions = try? JSONDecoder().decode([String].self, from: jsonData) {
            return Array(questions.prefix(3))
        }
        return ["What happened?", "Why does this matter?", "What's next?"]
    }

    func chat(messages: [ChatMessage], articleContext: String) async throws -> String {
        let system = """
        You are Layman, a friendly AI that explains news simply. Answer in 1-2 sentences max. Keep it casual and easy to understand.
        Article context: \(articleContext.prefix(500))
        """

        var apiMessages: [[String: String]] = [["role": "system", "content": system]]
        for msg in messages {
            apiMessages.append([
                "role": msg.role == .user ? "user" : "assistant",
                "content": msg.content
            ])
        }

        let body: [String: Any] = [
            "model": "llama3-8b-8192",
            "messages": apiMessages,
            "temperature": 0.7,
            "max_tokens": 100
        ]

        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(GroqResponse.self, from: data)
        return response.choices.first?.message.content ?? "I couldn't get a response."
    }
}

// MARK: - Response Models
struct GroqResponse: Decodable {
    let choices: [GroqChoice]
}

struct GroqChoice: Decodable {
    let message: GroqMessage
}

struct GroqMessage: Decodable {
    let content: String
}
