import Foundation
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isAuthenticated = false

    func signIn(email: String, password: String) async {
        guard validate(email: email, password: password) else { return }
        isLoading = true
        errorMessage = nil
        do {
            try await SupabaseService.shared.signIn(email: email, password: password)
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func signUp(email: String, password: String, confirmPassword: String) async {
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }
        guard validate(email: email, password: password) else { return }
        isLoading = true
        errorMessage = nil
        do {
            try await SupabaseService.shared.signUp(email: email, password: password)
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    private func validate(email: String, password: String) -> Bool {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            return false
        }
        guard email.contains("@"), email.contains(".") else {
            errorMessage = "Please enter a valid email."
            return false
        }
        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters."
            return false
        }
        return true
    }
}
