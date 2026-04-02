import SwiftUI
import Auth

struct ProfileView: View {
    @State private var showSignOutConfirm = false
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("simplifyByDefault") private var simplifyByDefault = true

    private var userEmail: String {
        SupabaseService.shared.currentUser?.email ?? "Guest"
    }

    private var displayName: String {
        userEmail.components(separatedBy: "@").first?.capitalized ?? "User"
    }

    private var initials: String {
        String(displayName.prefix(1)).uppercased()
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {

                    // Header
                    HStack {
                        Text("Profile")
                            .appFont(size: 28, weight: .bold, design: .serif)
                            .foregroundColor(AppTheme.textPrimary)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)

                    // Avatar + user info card
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [AppTheme.gradientStart, AppTheme.accentOrange],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 88, height: 88)
                            Text(initials)
                                .appFont(size: 36, weight: .bold)
                                .foregroundColor(.white)
                        }

                        Text(displayName)
                            .appFont(size: 20, weight: .bold)
                            .foregroundColor(AppTheme.textPrimary)

                        Text(userEmail)
                            .appFont(size: 14, weight: .regular)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 28)
                    .background(AppTheme.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                    .padding(.horizontal, 20)

                    // Preferences
                    settingsSection(title: "Preferences") {
                        toggleRow(
                            icon: "bell.fill",
                            title: "Notifications",
                            subtitle: "Daily news updates",
                            isOn: $notificationsEnabled
                        )
                        Divider().padding(.horizontal, 16)
                        toggleRow(
                            icon: "text.bubble.fill",
                            title: "Simplify by default",
                            subtitle: "Always show Layman version",
                            isOn: $simplifyByDefault
                        )
                    }

                    // About
                    settingsSection(title: "About") {
                        infoRow(icon: "info.circle.fill", title: "Version", value: "1.0.0")
                        Divider().padding(.horizontal, 16)
                        infoRow(icon: "globe", title: "Category", value: "Business · Tech · Startups")
                        Divider().padding(.horizontal, 16)
                        infoRow(icon: "brain.fill", title: "AI Model", value: "Groq llama-3.1-8b")
                    }

                    // Sign out
                    Button {
                        showSignOutConfirm = true
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .appFont(size: 16, weight: .semibold)
                            Text("Sign Out")
                                .appFont(size: 16, weight: .semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(AppTheme.accentOrange)
                        .clipShape(Capsule())
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
                }
            }
            .background(Color.white)
            .navigationBarHidden(true)
            .confirmationDialog("Are you sure you want to sign out?", isPresented: $showSignOutConfirm, titleVisibility: .visible) {
                Button("Sign Out", role: .destructive) {
                    Task { try? await SupabaseService.shared.signOut() }
                }
                Button("Cancel", role: .cancel) {}
            }
        }
    }

    // MARK: - Helpers
    @ViewBuilder
    private func settingsSection(title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .appFont(size: 13, weight: .semibold)
                .foregroundColor(.gray)
                .padding(.horizontal, 20)
                .padding(.bottom, 8)

            VStack(spacing: 0) {
                content()
            }
            .background(AppTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
            .padding(.horizontal, 20)
        }
    }

    @ViewBuilder
    private func toggleRow(icon: String, title: String, subtitle: String, isOn: Binding<Bool>) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .appFont(size: 16, weight: .medium)
                .foregroundColor(AppTheme.accentOrange)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .appFont(size: 15, weight: .medium)
                    .foregroundColor(AppTheme.textPrimary)
                Text(subtitle)
                    .appFont(size: 12, weight: .regular)
                    .foregroundColor(.gray)
            }

            Spacer()

            Toggle("", isOn: isOn)
                .tint(AppTheme.accentOrange)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    @ViewBuilder
    private func infoRow(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .appFont(size: 16, weight: .medium)
                .foregroundColor(AppTheme.accentOrange)
                .frame(width: 28)

            Text(title)
                .appFont(size: 15, weight: .medium)
                .foregroundColor(AppTheme.textPrimary)

            Spacer()

            Text(value)
                .appFont(size: 13, weight: .regular)
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

#Preview {
    ProfileView()
}
