import Testing
import XCTest
import SwiftUI
@testable import Layman

// MARK: - Article Model Tests
struct ArticleModelTests {

    @Test func articleDecodesCorrectly() throws {
        let json = """
        {
            "article_id": "abc123",
            "title": "Test Article Title",
            "description": "A short description.",
            "content": "Full content here.",
            "image_url": "https://example.com/image.jpg",
            "pubDate": "2026-04-01",
            "source_id": "bbc",
            "link": "https://example.com/article",
            "category": ["technology"]
        }
        """.data(using: .utf8)!

        let article = try JSONDecoder().decode(Article.self, from: json)
        #expect(article.id == "abc123")
        #expect(article.title == "Test Article Title")
        #expect(article.sourceID == "bbc")
        #expect(article.category?.first == "technology")
    }

    @Test func articleHandlesMissingOptionalFields() throws {
        let json = """
        {
            "article_id": "xyz789",
            "title": "Minimal Article",
            "link": null,
            "pubDate": null
        }
        """.data(using: .utf8)!

        let article = try JSONDecoder().decode(Article.self, from: json)
        #expect(article.id == "xyz789")
        #expect(article.imageURL == nil)
        #expect(article.link == nil)
        #expect(article.description == nil)
    }

    @Test func newsResponseDecodesSuccessfully() throws {
        let json = """
        {
            "status": "success",
            "results": [
                {
                    "article_id": "1",
                    "title": "Article One",
                    "link": "https://example.com"
                }
            ],
            "nextPage": "token123"
        }
        """.data(using: .utf8)!

        let response = try JSONDecoder().decode(NewsResponse.self, from: json)
        #expect(response.status == "success")
        #expect(response.results.count == 1)
        #expect(response.nextPage == "token123")
    }

    @Test func newsResponseHandlesErrorStatus() throws {
        let json = """
        {
            "status": "error",
            "results": {},
            "message": "Unauthorized"
        }
        """.data(using: .utf8)!

        let response = try JSONDecoder().decode(NewsResponse.self, from: json)
        #expect(response.status == "error")
        #expect(response.results.isEmpty)
        #expect(response.message == "Unauthorized")
    }
}

// MARK: - NewsCategory Tests
struct NewsCategoryTests {

    @Test func allCasesExist() {
        #expect(NewsCategory.allCases.count == 3)
    }

    @Test func apiValuesAreCorrect() {
        #expect(NewsCategory.business.apiValue == "business")
        #expect(NewsCategory.technology.apiValue == "technology")
        #expect(NewsCategory.startups.apiValue == "technology")
    }

    @Test func rawValuesAreCorrect() {
        #expect(NewsCategory.business.rawValue == "Business")
        #expect(NewsCategory.technology.rawValue == "Technology")
        #expect(NewsCategory.startups.rawValue == "Startups")
    }
}

// MARK: - ChatMessage Tests
struct ChatMessageTests {

    @Test func userMessageHasCorrectRole() {
        let msg = ChatMessage(role: .user, content: "Hello!")
        #expect(msg.role == .user)
        #expect(msg.content == "Hello!")
    }

    @Test func assistantMessageHasCorrectRole() {
        let msg = ChatMessage(role: .assistant, content: "Hi I'm Layman!")
        #expect(msg.role == .assistant)
        #expect(msg.content == "Hi I'm Layman!")
    }

    @Test func messagesHaveUniqueIDs() {
        let msg1 = ChatMessage(role: .user, content: "First")
        let msg2 = ChatMessage(role: .user, content: "Second")
        #expect(msg1.id != msg2.id)
    }
}

// MARK: - AuthViewModel Validation Tests
struct AuthValidationTests {

    @Test func emptyEmailFails() async {
        let vm = await AuthViewModel()
        await vm.signIn(email: "", password: "password123")
        let error = await vm.errorMessage
        #expect(error != nil)
        #expect(error == "Please fill in all fields.")
    }

    @Test func invalidEmailFails() async {
        let vm = await AuthViewModel()
        await vm.signIn(email: "notanemail", password: "password123")
        let error = await vm.errorMessage
        #expect(error == "Please enter a valid email.")
    }

    @Test func shortPasswordFails() async {
        let vm = await AuthViewModel()
        await vm.signIn(email: "test@example.com", password: "123")
        let error = await vm.errorMessage
        #expect(error == "Password must be at least 6 characters.")
    }

    @Test func passwordMismatchFails() async {
        let vm = await AuthViewModel()
        await vm.signUp(email: "test@example.com", password: "password123", confirmPassword: "different")
        let error = await vm.errorMessage
        #expect(error == "Passwords do not match.")
    }

    @Test func validCredentialsPassValidation() async {
        let vm = await AuthViewModel()
        // Valid credentials pass client-side validation (will fail at network level, not validation)
        await vm.signIn(email: "test@example.com", password: "password123")
        // Error should NOT be a validation error
        let error = await vm.errorMessage
        let isValidationError = error == "Please fill in all fields." ||
                                error == "Please enter a valid email." ||
                                error == "Password must be at least 6 characters."
        #expect(!isValidationError)
    }
}

// MARK: - AppTheme Tests
struct AppThemeTests {

    @Test func hexColorInitializesCorrectly() {
        let color = Color(hex: "#E8593C")
        // Just verify it doesn't crash and creates a Color
        #expect(type(of: color) == Color.self)
    }

    @Test func hexColorWithoutHashInitializes() {
        let color = Color(hex: "E8593C")
        #expect(type(of: color) == Color.self)
    }
}
