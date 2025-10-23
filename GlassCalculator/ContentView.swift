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
    @Environment(\.colorScheme) var systemColorScheme
    @State private var showPremiumSheet = false
    @AppStorage("userPreferredColorScheme") private var userPreferredColorScheme: Int = 0 // 0 = system, 1 = light, 2 = dark

    // Computed property para el color scheme actual
    private var currentColorScheme: ColorScheme {
        switch userPreferredColorScheme {
        case 1: return .light
        case 2: return .dark
        default: return systemColorScheme
        }
    }

    var body: some View {
        ZStack {
            // Dynamic background with gradient
            backgroundGradient
                .ignoresSafeArea()

            // Calculator siempre visible
            CalculatorView(showPremiumSheet: $showPremiumSheet, userPreferredColorScheme: $userPreferredColorScheme)
        }
        .preferredColorScheme(userPreferredColorScheme == 0 ? nil : (userPreferredColorScheme == 1 ? .light : .dark))
        .sheet(isPresented: $showPremiumSheet) {
            PremiumPurchaseSheet()
                .environmentObject(storeManager)
                .preferredColorScheme(userPreferredColorScheme == 0 ? nil : (userPreferredColorScheme == 1 ? .light : .dark))
        }
    }

    private var backgroundGradient: some View {
        LinearGradient(
            colors: currentColorScheme == .dark
                ? [Color(hex: "0D1117"), Color(hex: "161B22"), Color(hex: "1F2937"), Color(hex: "2D3748")]
                : [Color(hex: "E8F4F8"), Color(hex: "D4E9F2"), Color(hex: "C0DEF0")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .animation(.easeInOut(duration: 0.8), value: currentColorScheme)
    }
}

struct CalculatorView: View {
    @EnvironmentObject var viewModel: CalculatorViewModel
    @EnvironmentObject var storeManager: StoreManager
    @Environment(\.colorScheme) var colorScheme
    @State private var buttonScale: [String: CGFloat] = [:]
    @Binding var showPremiumSheet: Bool
    @Binding var userPreferredColorScheme: Int

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
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Top bar with theme and premium buttons
                topBar
                    .padding(.horizontal, 20)
                    .padding(.top, max(geometry.safeAreaInsets.top, 8) + 8)

                Spacer()

                // Display with liquid glass effect
                displayView
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.95).combined(with: .opacity),
                        removal: .scale(scale: 1.05).combined(with: .opacity)
                    ))

                // Button grid
                buttonGrid
                    .padding(.horizontal, 20)
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom, 20) + 8)
            }
        }
    }

    private var topBar: some View {
        HStack(spacing: 12) {
            // Development mode indicator
            #if DEBUG
            developmentBanner
            #endif

            Spacer()

            // Theme toggle button
            themeToggleButton

            // Premium button (solo mostrar si no está desbloqueado)
            if !storeManager.isPremiumUnlocked {
                Button {
                    showPremiumSheet = true
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 12))
                        Text("Premium")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                    }
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "FF9F0A"), Color(hex: "FF8C00")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background {
                        Capsule()
                            .fill(.ultraThinMaterial)
                            .overlay {
                                Capsule()
                                    .stroke(
                                        LinearGradient(
                                            colors: [Color(hex: "FF9F0A").opacity(0.5), Color(hex: "FF8C00").opacity(0.3)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ),
                                        lineWidth: 1.5
                                    )
                            }
                            .shadow(color: Color(hex: "FF9F0A").opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var themeToggleButton: some View {
        Button {
            // Ciclar entre: system (0) -> light (1) -> dark (2) -> system (0)
            withAnimation(.interpolatingSpring(stiffness: 250, damping: 20)) {
                userPreferredColorScheme = (userPreferredColorScheme + 1) % 3
            }

            // Haptic feedback
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
        } label: {
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)

                // Subtle inner glow
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.white.opacity(colorScheme == .dark ? 0.08 : 0.3),
                                Color.clear
                            ],
                            center: .topLeading,
                            startRadius: 0,
                            endRadius: 20
                        )
                    )
                    .blendMode(.overlay)

                // Border
                Circle()
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(colorScheme == .dark ? 0.3 : 0.6),
                                Color.white.opacity(colorScheme == .dark ? 0.1 : 0.3)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.2
                    )

                // Icon with transition
                Image(systemName: themeIconName)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(colorScheme == .dark ? .white : Color(hex: "1A1F3A"))
                    .transition(.scale.combined(with: .opacity))
                    .id(themeIconName) // Force view recreation for smooth transition
            }
            .frame(width: 36, height: 36)
            .shadow(color: .black.opacity(colorScheme == .dark ? 0.4 : 0.08), radius: 8, x: 0, y: 4)
            .shadow(color: colorScheme == .dark ? Color.white.opacity(0.05) : Color.white.opacity(0.3), radius: 0.5, x: 0, y: -0.5)
        }
        .buttonStyle(.plain)
    }

    private var themeIconName: String {
        switch userPreferredColorScheme {
        case 0: return "circle.lefthalf.filled" // System
        case 1: return "sun.max.fill" // Light
        case 2: return "moon.fill" // Dark
        default: return "circle.lefthalf.filled"
        }
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
                    .foregroundStyle(colorScheme == .dark ? Color.white.opacity(0.6) : Color.primary.opacity(0.6))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .top).combined(with: .opacity).combined(with: .scale(scale: 0.9)),
                            removal: .move(edge: .top).combined(with: .opacity).combined(with: .scale(scale: 1.1))
                        )
                    )
            }

            // Main display
            Text(viewModel.displayText)
                .font(.system(size: 72, weight: .thin, design: .rounded))
                .fontDesign(.rounded)
                .foregroundStyle(colorScheme == .dark ? Color.white : Color.primary)
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
        .animation(.interpolatingSpring(stiffness: 200, damping: 18), value: viewModel.displayText)
    }

    private var liquidGlassBackground: some View {
        ZStack {
            // Base glass effect
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(.ultraThinMaterial)

            // Inner glow
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: colorScheme == .dark
                            ? [Color.white.opacity(0.08), Color.clear]
                            : [Color.white.opacity(0.6), Color.clear],
                        startPoint: .topLeading,
                        endPoint: .center
                    )
                )
                .blendMode(colorScheme == .dark ? .plusLighter : .overlay)

            // Border with gradient
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: colorScheme == .dark
                            ? [Color.white.opacity(0.4), Color.white.opacity(0.1), Color.white.opacity(0.05)]
                            : [Color.white.opacity(0.9), Color.white.opacity(0.6), Color.white.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        }
        .shadow(color: .black.opacity(colorScheme == .dark ? 0.6 : 0.1), radius: 24, x: 0, y: 12)
        .shadow(color: colorScheme == .dark ? Color.white.opacity(0.05) : Color.white.opacity(0.3), radius: 1, x: 0, y: -1)
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

        // Smooth press animation (iOS 26 style)
        withAnimation(.interpolatingSpring(stiffness: 300, damping: 15)) {
            buttonScale[button.rawValue] = 0.92
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            withAnimation(.interpolatingSpring(stiffness: 200, damping: 12)) {
                buttonScale[button.rawValue] = 1.0
            }
        }

        // Process button action with slight delay for feel
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
            viewModel.buttonTapped(button)
        }
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
        ZStack {
            // Base button with glass effect
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(button.backgroundColor(for: colorScheme))

            // Inner highlight for liquid glass effect
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(colorScheme == .dark ? 0.1 : 0.3),
                            Color.clear
                        ],
                        startPoint: .topLeading,
                        endPoint: .center
                    )
                )
                .blendMode(.overlay)

            // Border gradient
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(colorScheme == .dark ? 0.25 : 0.6),
                            Color.white.opacity(colorScheme == .dark ? 0.08 : 0.3),
                            Color.white.opacity(colorScheme == .dark ? 0.05 : 0.2)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.2
                )
        }
        .shadow(color: .black.opacity(colorScheme == .dark ? 0.5 : 0.12), radius: 10, x: 0, y: 5)
        .shadow(color: colorScheme == .dark ? Color.white.opacity(0.03) : Color.white.opacity(0.4), radius: 0.5, x: 0, y: -0.5)
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
