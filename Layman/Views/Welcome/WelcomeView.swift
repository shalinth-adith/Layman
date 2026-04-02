import SwiftUI

struct WelcomeView: View {
    @State private var navigateToAuth = false
    @State private var dragOffset: CGFloat = 0

    private let sliderWidth: CGFloat = 300
    private let thumbSize: CGFloat = 56
    private var maxDrag: CGFloat { sliderWidth - thumbSize - 8 }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    stops: [
                        .init(color: Color(hex: "#F0A882"), location: 0.0),
                        .init(color: AppTheme.gradientStart, location: 0.3),
                        .init(color: Color(hex: "#FFF8F4"), location: 0.5),
                        .init(color: AppTheme.gradientStart, location: 0.7),
                        .init(color: Color(hex: "#F0A882"), location: 1.0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Logo at top center
                    Text("Layman")
                        .appFont(size: 52, weight: .bold, design: .serif)
                        .foregroundColor(AppTheme.textPrimary)
                        .padding(.top, 60)
                        .frame(maxWidth: .infinity, alignment: .center)

                    Spacer()

                    // Slogan in middle
                    VStack(spacing: 8) {
                        Text("Business,")
                            .appFont(size: 38, weight: .semibold)
                            .foregroundColor(AppTheme.textPrimary)
                        Text("tech & startups")
                            .appFont(size: 38, weight: .semibold)
                            .foregroundColor(AppTheme.textPrimary)
                        Text("made simple")
                            .appFont(size: 38, weight: .bold)
                            .foregroundColor(AppTheme.accentOrange)
                    }
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                    Spacer()

                    // Slide to get started
                    ZStack(alignment: .leading) {
                        // Track
                        Capsule()
                            .fill(Color(hex: "#C44A30").opacity(0.7))
                            .frame(width: sliderWidth, height: thumbSize + 8)

                        // Label
                        Text("Swipe to get started")
                            .appFont(size: 15, weight: .medium)
                            .foregroundColor(.white.opacity(0.9))
                            .frame(width: sliderWidth)
                            .opacity(Double(1 - (dragOffset / maxDrag)))

                        // Thumb
                        Circle()
                            .fill(Color.white)
                            .frame(width: thumbSize, height: thumbSize)
                            .overlay(
                                Image(systemName: "chevron.right.2")
                                    .foregroundColor(AppTheme.accentOrange)
                                    .appFont(size: 18, weight: .semibold)
                            )
                            .offset(x: dragOffset + 4)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        let newOffset = min(max(0, value.translation.width), maxDrag)
                                        dragOffset = newOffset
                                    }
                                    .onEnded { _ in
                                        if dragOffset > maxDrag * 0.85 {
                                            navigateToAuth = true
                                            dragOffset = maxDrag
                                        } else {
                                            withAnimation(.spring()) {
                                                dragOffset = 0
                                            }
                                        }
                                    }
                            )
                    }
                    .padding(.bottom, 60)
                }
            }
            .navigationDestination(isPresented: $navigateToAuth) {
                AuthView()
            }
        }
    }
}

#Preview {
    WelcomeView()
}
