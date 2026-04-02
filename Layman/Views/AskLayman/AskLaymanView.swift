import SwiftUI

struct AskLaymanView: View {
    let article: Article
    @StateObject private var viewModel: ChatViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isInputFocused: Bool
    @State private var scrollProxy: ScrollViewProxy? = nil

    init(article: Article) {
        self.article = article
        _viewModel = StateObject(wrappedValue: ChatViewModel(article: article))
    }

    var body: some View {
        VStack(spacing: 0) {

            // Header
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.down")
                        .appFont(size: 16, weight: .semibold)
                        .foregroundColor(AppTheme.textPrimary)
                        .padding(10)
                        .background(Color(hex: "#F0E8E0"))
                        .clipShape(Circle())
                }
                Spacer()
                Text("Ask Layman")
                    .appFont(size: 17, weight: .bold)
                    .foregroundColor(AppTheme.textPrimary)
                Spacer()
                // Balance spacing
                Color.clear.frame(width: 36, height: 36)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 12)

            Divider()

            // Chat messages
            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(viewModel.messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }

                        // Suggested questions (shown after initial message)
                        if viewModel.messages.count == 1 {
                            if viewModel.isLoadingQuestions {
                                HStack(spacing: 8) {
                                    ForEach(0..<3, id: \.self) { _ in
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color(hex: "#F0E8E0"))
                                            .frame(width: 100, height: 36)
                                    }
                                }
                                .padding(.leading, 16)
                            } else {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 10) {
                                        ForEach(viewModel.suggestedQuestions, id: \.self) { question in
                                            Button {
                                                Task { await viewModel.send(text: question) }
                                            } label: {
                                                Text(question)
                                                    .appFont(size: 13, weight: .medium)
                                                    .foregroundColor(.white)
                                                    .padding(.horizontal, 14)
                                                    .padding(.vertical, 10)
                                                    .background(AppTheme.accentOrange)
                                                    .clipShape(Capsule())
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                }
                            }
                        }

                        // Loading indicator
                        if viewModel.isLoading {
                            HStack(spacing: 6) {
                                BotAvatar()
                                TypingIndicator()
                            }
                            .padding(.leading, 16)
                            .id("typing")
                        }

                        Spacer().frame(height: 8)
                    }
                    .padding(.top, 16)
                }
                .onAppear { scrollProxy = proxy }
                .onChange(of: viewModel.messages.count) { _ in
                    withAnimation {
                        proxy.scrollTo(viewModel.messages.last?.id, anchor: .bottom)
                    }
                }
                .onChange(of: viewModel.isLoading) { _ in
                    withAnimation { proxy.scrollTo("typing", anchor: .bottom) }
                }
            }

            // Input bar
            VStack(spacing: 0) {
                Divider()
                HStack(spacing: 12) {
                    TextField("Type your question...", text: $viewModel.inputText)
                        .appFont(size: 15, weight: .regular)
                        .focused($isInputFocused)
                        .submitLabel(.send)
                        .onSubmit {
                            Task { await viewModel.send(text: viewModel.inputText) }
                        }

                    // Mic button
                    Button {} label: {
                        Image(systemName: "mic.fill")
                            .appFont(size: 16, weight: .medium)
                            .foregroundColor(.gray)
                    }

                    // Send button
                    Button {
                        Task { await viewModel.send(text: viewModel.inputText) }
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .foregroundColor(viewModel.inputText.isEmpty ? .gray.opacity(0.4) : AppTheme.accentOrange)
                            .appFont(size: 30, weight: .medium)
                    }
                    .disabled(viewModel.inputText.isEmpty || viewModel.isLoading)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.white)
            }
        }
        .background(Color(hex: "#FAF7F2"))
        .task { await viewModel.loadSuggestedQuestions() }
    }
}

// MARK: - Message Bubble
struct MessageBubble: View {
    let message: ChatMessage

    var isUser: Bool { message.role == .user }

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if !isUser { BotAvatar() }

            Text(message.content)
                .appFont(size: 15, weight: .regular)
                .foregroundColor(isUser ? .white : AppTheme.textPrimary)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(isUser ? AppTheme.accentOrange : Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.72, alignment: isUser ? .trailing : .leading)

            if isUser { Spacer().frame(width: 4) }
        }
        .frame(maxWidth: .infinity, alignment: isUser ? .trailing : .leading)
        .padding(.horizontal, 16)
    }
}

// MARK: - Bot Avatar
struct BotAvatar: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(AppTheme.accentOrange)
                .frame(width: 32, height: 32)
            Text("L")
                .appFont(size: 14, weight: .bold)
                .foregroundColor(.white)
        }
    }
}

// MARK: - Typing Indicator
struct TypingIndicator: View {
    @State private var animate = false

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 7, height: 7)
                    .offset(y: animate ? -4 : 0)
                    .animation(.easeInOut(duration: 0.4).repeatForever().delay(Double(i) * 0.15), value: animate)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .onAppear { animate = true }
    }
}
