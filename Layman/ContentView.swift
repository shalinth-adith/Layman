import SwiftUI
import Supabase

struct ContentView: View {
    @State private var isLoggedIn = false
    @State private var isChecking = true

    var body: some View {
        Group {
            if isChecking {
                // Splash while checking session
                ZStack {
                    AppTheme.warmGradient.ignoresSafeArea()
                    Text("Layman")
                        .appFont(size: 48, weight: .bold, design: .serif)
                        .foregroundColor(.white)
                }
            } else if isLoggedIn {
                MainTabView()
            } else {
                WelcomeView()
            }
        }
        .task {
            isLoggedIn = SupabaseService.shared.currentUser != nil
            isChecking = false

            // Listen for auth state changes
            for await _ in SupabaseService.shared.client.auth.authStateChanges {
                isLoggedIn = SupabaseService.shared.currentUser != nil
            }
        }
    }
}

#Preview {
    ContentView()
}
