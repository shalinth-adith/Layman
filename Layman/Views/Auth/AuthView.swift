import SwiftUI

struct AuthView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var isLogin = true
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    var body: some View {
        ZStack {
            AppTheme.warmGradient
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    // Title
                    Text("Layman")
                        .appFont(size: 40, weight: .bold, design: .serif)
                        .foregroundColor(AppTheme.textPrimary)
                        .padding(.top, 60)
                        .padding(.bottom, 40)

                    // Card
                    VStack(spacing: 20) {

                        // Toggle
                        HStack(spacing: 0) {
                            toggleButton(title: "Login", selected: isLogin) {
                                withAnimation { isLogin = true }
                            }
                            toggleButton(title: "Sign Up", selected: !isLogin) {
                                withAnimation { isLogin = false }
                            }
                        }
                        .background(Color(hex: "#F0E8E0"))
                        .clipShape(Capsule())

                        // Fields
                        VStack(spacing: 14) {
                            inputField(placeholder: "Email", text: $email, isSecure: false)

                            inputField(placeholder: "Password", text: $password, isSecure: true)

                            if !isLogin {
                                inputField(placeholder: "Confirm Password", text: $confirmPassword, isSecure: true)
                            }
                        }

                        // Error
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .appFont(size: 13, weight: .medium)
                                .foregroundColor(AppTheme.accentOrange)
                                .multilineTextAlignment(.center)
                        }

                        // Skip button
                        Button {
                            viewModel.isAuthenticated = true
                        } label: {
                            Text("Skip for now")
                                .appFont(size: 14, weight: .medium)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity)
                        }

                        // Action button
                        Button {
                            Task {
                                if isLogin {
                                    await viewModel.signIn(email: email, password: password)
                                } else {
                                    await viewModel.signUp(email: email, password: password, confirmPassword: confirmPassword)
                                }
                            }
                        } label: {
                            ZStack {
                                Capsule()
                                    .fill(AppTheme.accentOrange)
                                    .frame(height: 52)
                                if viewModel.isLoading {
                                    ProgressView().tint(.white)
                                } else {
                                    Text(isLogin ? "Login" : "Create Account")
                                        .appFont(size: 16, weight: .semibold)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .disabled(viewModel.isLoading)
                    }
                    .padding(24)
                    .background(AppTheme.cardBackground)
                    .cornerRadius(24)
                    .padding(.horizontal, 24)
                }
            }
        }
        .navigationBarHidden(true)
    }

    @ViewBuilder
    private func toggleButton(title: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .appFont(size: 15, weight: selected ? .semibold : .regular)
                .foregroundColor(selected ? .white : AppTheme.textPrimary.opacity(0.6))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(selected ? AppTheme.accentOrange : Color.clear)
                .clipShape(Capsule())
        }
    }

    @ViewBuilder
    private func inputField(placeholder: String, text: Binding<String>, isSecure: Bool) -> some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: text)
                    .textContentType(.oneTimeCode)
            } else {
                TextField(placeholder, text: text)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .autocorrectionDisabled(true)
                    .textContentType(.emailAddress)
            }
        }
        .appFont(size: 15, weight: .regular)
        .padding(14)
        .background(Color(hex: "#F0E8E0"))
        .cornerRadius(12)
    }
}

#Preview {
    AuthView()
}
