//
//  ContentView.swift
//  GlassCalculator
//
//  Premium Calculator with Liquid Glass Design
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var calculatorViewModel: CalculatorViewModel
    @EnvironmentObject var storeManager: StoreManager
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            // Dynamic background with gradient
            backgroundGradient
                .ignoresSafeArea()

            if storeManager.isPremiumUnlocked {
                CalculatorView()
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity),
                        removal: .scale.combined(with: .opacity)
                    ))
            } else {
                PremiumPurchaseView()
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity),
                        removal: .scale.combined(with: .opacity)
                    ))
            }
        }
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: storeManager.isPremiumUnlocked)
    }

    private var backgroundGradient: some View {
        LinearGradient(
            colors: colorScheme == .dark
                ? [Color(hex: "0A0E27"), Color(hex: "1A1F3A"), Color(hex: "2A2F4A")]
                : [Color(hex: "E8F4F8"), Color(hex: "D4E9F2"), Color(hex: "C0DEF0")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

struct CalculatorView: View {
    @EnvironmentObject var viewModel: CalculatorViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var buttonScale: [String: CGFloat] = [:]

    private let buttonLayout: [[CalculatorButton]] = [
        [.clear, .negate, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equals]
    ]

    #if DEBUG
    private let isDevelopmentMode = true
    #else
    private let isDevelopmentMode = false
    #endif

    var body: some View {
        VStack(spacing: 0) {
            // Development mode indicator
            #if DEBUG
            developmentBanner
            #endif

            Spacer()

            // Display with liquid glass effect
            displayView
                .padding(.horizontal, 24)
                .padding(.bottom, 32)

            // Button grid
            buttonGrid
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
        }
        .statusBar(hidden: false)
    }

    #if DEBUG
    private var developmentBanner: some View {
        HStack(spacing: 8) {
            Image(systemName: "hammer.fill")
                .font(.system(size: 12))
            Text("Development Mode")
                .font(.system(size: 13, weight: .medium, design: .rounded))
        }
        .foregroundStyle(.orange)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background {
            Capsule()
                .fill(.ultraThinMaterial)
                .overlay {
                    Capsule()
                        .stroke(Color.orange.opacity(0.5), lineWidth: 1)
                }
        }
        .padding(.top, 8)
    }
    #endif

    private var displayView: some View {
        VStack(alignment: .trailing, spacing: 12) {
            // Secondary display (operation history)
            if !viewModel.operationText.isEmpty {
                Text(viewModel.operationText)
                    .font(.system(size: 24, weight: .regular, design: .rounded))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }

            // Main display
            Text(viewModel.displayText)
                .font(.system(size: 72, weight: .thin, design: .rounded))
                .fontDesign(.rounded)
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.3)
                .contentTransition(.numericText(value: Double(viewModel.displayText.filter { $0.isNumber || $0 == "." }) ?? 0))
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.vertical, 32)
        .padding(.horizontal, 28)
        .background {
            liquidGlassBackground
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: viewModel.displayText)
    }

    private var liquidGlassBackground: some View {
        RoundedRectangle(cornerRadius: 32, style: .continuous)
            .fill(.ultraThinMaterial)
            .overlay {
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: colorScheme == .dark
                                ? [Color.white.opacity(0.3), Color.white.opacity(0.1)]
                                : [Color.white.opacity(0.8), Color.white.opacity(0.4)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            }
            .shadow(color: .black.opacity(colorScheme == .dark ? 0.5 : 0.1), radius: 20, x: 0, y: 10)
    }

    private var buttonGrid: some View {
        VStack(spacing: 14) {
            ForEach(buttonLayout, id: \.self) { row in
                HStack(spacing: 14) {
                    ForEach(row, id: \.self) { button in
                        CalculatorButtonView(
                            button: button,
                            scale: buttonScale[button.rawValue] ?? 1.0
                        ) {
                            handleButtonTap(button)
                        }
                    }
                }
            }
        }
    }

    private func handleButtonTap(_ button: CalculatorButton) {
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()

        // Scale animation
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            buttonScale[button.rawValue] = 0.9
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                buttonScale[button.rawValue] = 1.0
            }
        }

        // Process button action
        viewModel.buttonTapped(button)
    }
}

struct CalculatorButtonView: View {
    let button: CalculatorButton
    let scale: CGFloat
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Button(action: action) {
            Text(button.title)
                .font(.system(size: button == .zero ? 32 : 32, weight: .medium, design: .rounded))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .frame(height: 75)
                .background {
                    buttonBackground
                }
        }
        .scaleEffect(scale)
        .buttonStyle(.plain)
    }

    private var buttonBackground: some View {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(button.backgroundColor(for: colorScheme))
            .overlay {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(colorScheme == .dark ? 0.2 : 0.5),
                                Color.white.opacity(colorScheme == .dark ? 0.05 : 0.2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            }
            .shadow(color: .black.opacity(colorScheme == .dark ? 0.3 : 0.1), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
