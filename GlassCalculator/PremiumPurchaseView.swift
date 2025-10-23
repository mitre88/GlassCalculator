//
//  PremiumPurchaseView.swift
//  GlassCalculator
//
//  Premium Purchase Screen with Liquid Glass Design
//

import SwiftUI
import StoreKit

struct PremiumPurchaseView: View {
    @EnvironmentObject var storeManager: StoreManager
    @Environment(\.colorScheme) var colorScheme
    @State private var isAnimating = false
    @State private var showFeatures = false

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // App Icon & Title
                appHeader

                // Features List
                featuresSection

                // Purchase Button
                purchaseSection

                // Restore Button
                restoreButton

                // Footer
                footerSection
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 40)
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2)) {
                showFeatures = true
            }
        }
    }

    private var appHeader: some View {
        VStack(spacing: 16) {
            // App Icon with glass effect
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: colorScheme == .dark
                                ? [Color(hex: "4A90E2"), Color(hex: "357ABD")]
                                : [Color(hex: "5BA3F5"), Color(hex: "4A90E2")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .overlay {
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.5), Color.white.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    }
                    .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)

                Image(systemName: "function")
                    .font(.system(size: 50, weight: .light))
                    .foregroundStyle(.white)
            }
            .scaleEffect(isAnimating ? 1.0 : 0.8)
            .opacity(isAnimating ? 1.0 : 0.0)
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    isAnimating = true
                }
            }

            Text("Glass Calculator")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: colorScheme == .dark
                            ? [.white, Color.white.opacity(0.8)]
                            : [Color(hex: "1A1F3A"), Color(hex: "2A2F4A")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Text("Premium Calculator Experience")
                .font(.system(size: 17, weight: .medium, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .padding(.top, 20)
    }

    private var featuresSection: some View {
        VStack(spacing: 16) {
            FeatureRow(
                icon: "sparkles",
                title: "Liquid Glass Design",
                description: "Beautiful iOS 26 native design",
                delay: 0.1
            )

            FeatureRow(
                icon: "moon.stars.fill",
                title: "Dark Mode Support",
                description: "Seamless light & dark themes",
                delay: 0.2
            )

            FeatureRow(
                icon: "waveform.path",
                title: "Smooth Animations",
                description: "Fluid interactions & transitions",
                delay: 0.3
            )

            FeatureRow(
                icon: "bolt.fill",
                title: "Lightning Fast",
                description: "Optimized performance",
                delay: 0.4
            )

            FeatureRow(
                icon: "lock.fill",
                title: "Privacy First",
                description: "No ads, no tracking, no data collection",
                delay: 0.5
            )

            FeatureRow(
                icon: "arrow.clockwise",
                title: "Lifetime Access",
                description: "One-time purchase, yours forever",
                delay: 0.6
            )
        }
        .opacity(showFeatures ? 1 : 0)
        .offset(y: showFeatures ? 0 : 20)
    }

    private var purchaseSection: some View {
        VStack(spacing: 16) {
            if let product = storeManager.products.first {
                Button {
                    Task {
                        await storeManager.purchase(product)
                    }
                } label: {
                    HStack(spacing: 12) {
                        if storeManager.purchaseState == .purchasing {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Image(systemName: "crown.fill")
                                .font(.title3)

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Unlock Premium")
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                                Text(product.displayPrice)
                                    .font(.system(size: 14, weight: .regular, design: .rounded))
                                    .opacity(0.9)
                            }
                        }
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background {
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "FF9F0A"), Color(hex: "FF8C00")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay {
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .stroke(
                                        LinearGradient(
                                            colors: [Color.white.opacity(0.4), Color.white.opacity(0.1)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
                            }
                            .shadow(color: Color(hex: "FF9F0A").opacity(0.4), radius: 20, x: 0, y: 10)
                    }
                }
                .disabled(storeManager.purchaseState == .purchasing)
                .buttonStyle(.plain)
            } else {
                ProgressView()
                    .tint(.primary)
                    .frame(height: 60)
            }

            if let error = storeManager.errorMessage {
                Text(error)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
                    .transition(.opacity)
            }

            if storeManager.purchaseState == .success {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                    Text("Purchase Successful!")
                }
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(.green)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: storeManager.purchaseState)
        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: storeManager.errorMessage)
    }

    private var restoreButton: some View {
        Button {
            Task {
                await storeManager.restorePurchases()
            }
        } label: {
            Text("Restore Purchase")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .buttonStyle(.plain)
    }

    private var footerSection: some View {
        VStack(spacing: 8) {
            Text("One-time purchase")
                .font(.system(size: 13, weight: .regular, design: .rounded))
                .foregroundStyle(.tertiary)

            Text("No subscription required")
                .font(.system(size: 13, weight: .regular, design: .rounded))
                .foregroundStyle(.tertiary)
        }
        .padding(.top, 8)
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    let delay: Double
    @Environment(\.colorScheme) var colorScheme
    @State private var isVisible = false

    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 48, height: 48)
                    .overlay {
                        Circle()
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

                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "FF9F0A"), Color(hex: "FF8C00")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }

            // Text
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)

                Text(description)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
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
                .shadow(color: .black.opacity(colorScheme == .dark ? 0.3 : 0.08), radius: 8, x: 0, y: 4)
        }
        .scaleEffect(isVisible ? 1.0 : 0.95)
        .opacity(isVisible ? 1.0 : 0.0)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.75).delay(delay)) {
                isVisible = true
            }
        }
    }
}

// MARK: - Premium Purchase Sheet (Compact Version)
struct PremiumPurchaseSheet: View {
    @EnvironmentObject var storeManager: StoreManager
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var isAnimating = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // App Icon & Title
                    headerSection

                    // Features List (Compact)
                    featuresSection

                    // Purchase Button
                    purchaseSection

                    // Restore Button
                    restoreButton
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
            }
            .background {
                backgroundGradient
                    .ignoresSafeArea()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                isAnimating = true
            }

            // Cargar productos si no están cargados
            Task {
                await storeManager.loadProducts()
            }
        }
    }

    private var backgroundGradient: some View {
        LinearGradient(
            colors: colorScheme == .dark
                ? [Color(hex: "0A0E27"), Color(hex: "1A1F3A")]
                : [Color(hex: "E8F4F8"), Color(hex: "D4E9F2")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var headerSection: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "FF9F0A"), Color(hex: "FF8C00")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .overlay {
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 2)
                    }
                    .shadow(color: Color(hex: "FF9F0A").opacity(0.4), radius: 20, x: 0, y: 10)

                Image(systemName: "crown.fill")
                    .font(.system(size: 36, weight: .light))
                    .foregroundStyle(.white)
            }
            .scaleEffect(isAnimating ? 1.0 : 0.8)
            .opacity(isAnimating ? 1.0 : 0.0)

            Text("Desbloquea Premium")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)

            Text("Experiencia completa sin límites")
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(.secondary)
        }
    }

    private var featuresSection: some View {
        VStack(spacing: 12) {
            CompactFeatureRow(icon: "sparkles", title: "Diseño Liquid Glass", color: Color(hex: "FF9F0A"))
            CompactFeatureRow(icon: "moon.stars.fill", title: "Modo Oscuro", color: Color(hex: "5BA3F5"))
            CompactFeatureRow(icon: "bolt.fill", title: "Sin Anuncios", color: Color(hex: "32D74B"))
            CompactFeatureRow(icon: "lock.fill", title: "Sin Rastreo", color: Color(hex: "BF5AF2"))
        }
    }

    private var purchaseSection: some View {
        VStack(spacing: 12) {
            if let product = storeManager.products.first {
                Button {
                    Task {
                        await storeManager.purchase(product)
                    }
                } label: {
                    HStack(spacing: 12) {
                        if storeManager.purchaseState == .purchasing {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Image(systemName: "crown.fill")
                                .font(.title3)

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Comprar Premium")
                                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                                Text(product.displayPrice)
                                    .font(.system(size: 14, weight: .regular, design: .rounded))
                                    .opacity(0.9)
                            }
                        }
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "FF9F0A"), Color(hex: "FF8C00")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: Color(hex: "FF9F0A").opacity(0.4), radius: 16, x: 0, y: 8)
                    }
                }
                .disabled(storeManager.purchaseState == .purchasing)
                .buttonStyle(.plain)
            } else {
                // Modo testing o cargando
                VStack(spacing: 12) {
                    #if DEBUG
                    // En modo desarrollo, mostrar botón de prueba
                    Button {
                        // Simular compra exitosa
                        storeManager.errorMessage = nil
                        withAnimation {
                            storeManager.purchaseState = .success
                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            dismiss()
                        }
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.title3)

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Simular Compra (Dev)")
                                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                                Text("$2.99")
                                    .font(.system(size: 14, weight: .regular, design: .rounded))
                                    .opacity(0.9)
                            }
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [Color(hex: "FF9F0A"), Color(hex: "FF8C00")],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .shadow(color: Color(hex: "FF9F0A").opacity(0.4), radius: 16, x: 0, y: 8)
                        }
                    }
                    .buttonStyle(.plain)

                    Text("ℹ️ Modo desarrollo - Compra simulada")
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                    #else
                    ProgressView()
                        .frame(height: 56)

                    Text("Cargando productos...")
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundStyle(.secondary)
                    #endif
                }
            }

            if let error = storeManager.errorMessage {
                Text(error)
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            }

            if storeManager.purchaseState == .success {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.circle.fill")
                    Text("¡Compra Exitosa!")
                }
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(.green)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        dismiss()
                    }
                }
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: storeManager.purchaseState)
    }

    private var restoreButton: some View {
        Button {
            Task {
                await storeManager.restorePurchases()
            }
        } label: {
            Text("Restaurar Compra")
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .buttonStyle(.plain)
        .disabled(storeManager.purchaseState == .purchasing)
    }
}

struct CompactFeatureRow: View {
    let icon: String
    let title: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 36, height: 36)

                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(color)
            }

            Text(title)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundStyle(.primary)

            Spacer()

            Image(systemName: "checkmark")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(color)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.ultraThinMaterial)
        }
    }
}
