import SwiftUI

struct WelcomeView: View {
    @State private var navigateToAuth = false
    @State private var arrowOpacity = 1.0
    @State private var dragOffset: CGFloat = 0

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.warmGradient
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    Spacer()

                    // Logo
                    Text("Layman")
                        .font(.system(size: 48, weight: .bold, design: .serif))
                        .foregroundColor(.white)

                    Spacer().frame(height: 16)

                    // Slogan
                    VStack(spacing: 4) {
                        Text("Business, tech & startups")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(.white.opacity(0.9))
                        Text("made simple")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(AppTheme.accentOrange)
                    }

                    Spacer()

                    // Swipe up prompt
                    VStack(spacing: 8) {
                        Text("Swipe up to get started")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))

                        Image(systemName: "chevron.up")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .opacity(arrowOpacity)
                            .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: arrowOpacity)
                    }
                    .padding(.bottom, 48)
                    .offset(y: dragOffset)
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.height < 0 {
                            dragOffset = value.translation.height * 0.3
                        }
                    }
                    .onEnded { value in
                        if value.translation.height < -60 {
                            navigateToAuth = true
                        }
                        withAnimation(.spring()) {
                            dragOffset = 0
                        }
                    }
            )
            .navigationDestination(isPresented: $navigateToAuth) {
                AuthView()
            }
            .onAppear {
                arrowOpacity = 0.3
            }
        }
    }
}

#Preview {
    WelcomeView()
}
