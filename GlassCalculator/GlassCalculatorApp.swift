//
//  GlassCalculatorApp.swift
//  GlassCalculator
//
//  Created with Claude Code
//

import SwiftUI
import StoreKit

@main
struct GlassCalculatorApp: App {
    @StateObject private var storeManager = StoreManager()
    @StateObject private var calculatorViewModel = CalculatorViewModel()
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(storeManager)
                .environmentObject(calculatorViewModel)
                .preferredColorScheme(nil) // Respect system theme
                .task {
                    await storeManager.loadProducts()
                }
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
                Task {
                    await storeManager.updatePurchaseStatus()
                }
            }
        }
    }
}
