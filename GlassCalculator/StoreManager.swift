//
//  StoreManager.swift
//  GlassCalculator
//
//  StoreKit Integration for Premium Features
//

import SwiftUI
import StoreKit

@MainActor
class StoreManager: ObservableObject {
    @Published var isPremiumUnlocked: Bool = false
    @Published var products: [Product] = []
    @Published var purchaseState: PurchaseState = .idle
    @Published var errorMessage: String?

    private var updateListenerTask: Task<Void, Error>?
    private let productIds: [String] = ["com.glasscalculator.premium"]

    // MARK: - Development Mode
    // Desbloquear automáticamente en modo DEBUG para desarrollo
    #if DEBUG
    private let isDevelopmentMode = true
    #else
    private let isDevelopmentMode = false
    #endif

    enum PurchaseState {
        case idle
        case purchasing
        case success
        case failed
        case restored
    }

    init() {
        // En modo desarrollo, desbloquear automáticamente
        if isDevelopmentMode {
            isPremiumUnlocked = true
            print("🔓 Development Mode: Premium unlocked automatically")
        }

        updateListenerTask = listenForTransactions()

        // Cargar el estado de compra en background (no bloquear)
        if !isDevelopmentMode {
            Task {
                await updatePurchaseStatus()
            }
        }
    }

    deinit {
        updateListenerTask?.cancel()
    }

    // MARK: - Load Products
    func loadProducts() async {
        // En modo desarrollo, saltar la carga de productos
        guard !isDevelopmentMode else {
            print("🔓 Development Mode: Skipping product loading")
            return
        }

        do {
            let loadedProducts = try await Product.products(for: productIds)
            self.products = loadedProducts.sorted { $0.price < $1.price }
        } catch {
            print("Failed to load products: \(error)")
            self.errorMessage = "Unable to load products. Please try again."
        }
    }

    // MARK: - Purchase Product
    func purchase(_ product: Product) async {
        guard purchaseState != .purchasing else { return }

        purchaseState = .purchasing
        errorMessage = nil

        do {
            let result = try await product.purchase()

            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await transaction.finish()
                await updatePurchaseStatus()
                purchaseState = .success

                // Haptic feedback
                let notification = UINotificationFeedbackGenerator()
                notification.notificationOccurred(.success)

            case .userCancelled:
                purchaseState = .idle

            case .pending:
                purchaseState = .idle
                errorMessage = "Purchase is pending approval."

            @unknown default:
                purchaseState = .failed
                errorMessage = "Unknown error occurred."
            }
        } catch {
            purchaseState = .failed
            errorMessage = "Purchase failed: \(error.localizedDescription)"
            print("Purchase failed: \(error)")
        }
    }

    // MARK: - Restore Purchases
    func restorePurchases() async {
        do {
            try await AppStore.sync()
            await updatePurchaseStatus()

            if isPremiumUnlocked {
                purchaseState = .restored

                // Haptic feedback
                let notification = UINotificationFeedbackGenerator()
                notification.notificationOccurred(.success)
            } else {
                errorMessage = "No previous purchases found."
            }
        } catch {
            errorMessage = "Restore failed: \(error.localizedDescription)"
            print("Restore failed: \(error)")
        }
    }

    // MARK: - Check Purchase Status
    func updatePurchaseStatus() async {
        var hasPremium = false

        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }

            if transaction.productID == "com.glasscalculator.premium" {
                hasPremium = true
            }
        }

        isPremiumUnlocked = hasPremium
    }

    // MARK: - Transaction Listener
    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached { @MainActor in
            for await result in Transaction.updates {
                guard case .verified(let transaction) = result else {
                    continue
                }

                await transaction.finish()
                await self.updatePurchaseStatus()
            }
        }
    }

    // MARK: - Verification
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
}

enum StoreError: Error {
    case failedVerification
}
