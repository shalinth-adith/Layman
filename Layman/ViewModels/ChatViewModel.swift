import Foundation
import Combine

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var suggestedQuestions: [String] = []
    @Published var isLoading = false
    @Published var isLoadingQuestions = true
    @Published var inputText = ""

    private let article: Article

    init(article: Article) {
        self.article = article
        messages = [
            ChatMessage(role: .assistant, content: "Hi, I'm Layman! What can I answer for you? 👋")
        ]
    }

    func loadSuggestedQuestions() async {
        isLoadingQuestions = true
        do {
            suggestedQuestions = try await GroqService.shared.generateQuestions(
                title: article.title,
                content: article.content ?? article.description ?? ""
            )
        } catch {
            suggestedQuestions = ["What happened?", "Why does this matter?", "What's next?"]
        }
        isLoadingQuestions = false
    }

    func send(text: String) async {
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let userMsg = ChatMessage(role: .user, content: text)
        messages.append(userMsg)
        inputText = ""
        isLoading = true

        do {
            let context = "\(article.title). \(article.description ?? "")"
            let reply = try await GroqService.shared.chat(messages: messages, articleContext: context)
            messages.append(ChatMessage(role: .assistant, content: reply))
        } catch {
            messages.append(ChatMessage(role: .assistant, content: "Sorry, I couldn't get a response. Try again!"))
        }
        isLoading = false
    }
}
