//
//  CalculatorViewModel.swift
//  GlassCalculator
//
//  Calculator Logic with Functional Programming
//

import SwiftUI
import Combine

enum CalculatorButton: String, Hashable {
    case zero = "0", one = "1", two = "2", three = "3", four = "4"
    case five = "5", six = "6", seven = "7", eight = "8", nine = "9"
    case add = "+", subtract = "−", multiply = "×", divide = "÷"
    case equals = "=", clear = "AC", negate = "±", percent = "%"
    case decimal = "."

    var title: String { rawValue }

    func backgroundColor(for colorScheme: ColorScheme) -> AnyShapeStyle {
        switch self {
        case .add, .subtract, .multiply, .divide, .equals:
            return AnyShapeStyle(
                LinearGradient(
                    colors: colorScheme == .dark
                        ? [Color(hex: "FF9F0A"), Color(hex: "FF7A00")]
                        : [Color(hex: "FF9F0A"), Color(hex: "FF8C00")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        case .clear, .negate, .percent:
            return AnyShapeStyle(
                colorScheme == .dark
                    ? Color(hex: "4A4A4E").opacity(0.9)
                    : Color(hex: "E5E5E5").opacity(0.9)
            )
        default:
            return AnyShapeStyle(
                colorScheme == .dark
                    ? Color(hex: "5A5A5E").opacity(0.85)
                    : Color.white.opacity(0.7)
            )
        }
    }
}

enum Operation {
    case add, subtract, multiply, divide

    func execute(_ lhs: Double, _ rhs: Double) -> Double {
        switch self {
        case .add: return lhs + rhs
        case .subtract: return lhs - rhs
        case .multiply: return lhs * rhs
        case .divide: return lhs / rhs
        }
    }

    var symbol: String {
        switch self {
        case .add: return "+"
        case .subtract: return "−"
        case .multiply: return "×"
        case .divide: return "÷"
        }
    }
}

@MainActor
class CalculatorViewModel: ObservableObject {
    @Published var displayText: String = "0"
    @Published var operationText: String = ""

    private var currentValue: Double = 0
    private var storedValue: Double?
    private var currentOperation: Operation?
    private var shouldResetDisplay: Bool = false
    private var isNewCalculation: Bool = true

    // MARK: - Functional Programming Approach
    func buttonTapped(_ button: CalculatorButton) {
        Task { @MainActor in
            await handleButtonAction(button)
        }
    }

    private func handleButtonAction(_ button: CalculatorButton) async {
        switch button {
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
            await handleNumberInput(button.rawValue)
        case .decimal:
            await handleDecimalInput()
        case .add, .subtract, .multiply, .divide:
            await handleOperation(operation: mapButtonToOperation(button))
        case .equals:
            await handleEquals()
        case .clear:
            await handleClear()
        case .negate:
            await handleNegate()
        case .percent:
            await handlePercent()
        }
    }

    // MARK: - Pure Functions for Calculator Logic
    private func mapButtonToOperation(_ button: CalculatorButton) -> Operation {
        switch button {
        case .add: return .add
        case .subtract: return .subtract
        case .multiply: return .multiply
        case .divide: return .divide
        default: return .add
        }
    }

    private func handleNumberInput(_ number: String) async {
        if shouldResetDisplay || displayText == "0" {
            displayText = number
            shouldResetDisplay = false
            isNewCalculation = false
        } else {
            // Limit digits
            guard displayText.filter({ $0.isNumber }).count < 12 else { return }
            displayText += number
        }
        currentValue = parseDisplayValue(displayText)
    }

    private func handleDecimalInput() async {
        if shouldResetDisplay {
            displayText = "0."
            shouldResetDisplay = false
        } else if !displayText.contains(".") {
            displayText += "."
        }
    }

    private func handleOperation(operation: Operation) async {
        if let stored = storedValue, let currentOp = currentOperation, !shouldResetDisplay {
            // Chain operations
            let result = currentOp.execute(stored, currentValue)
            storedValue = result
            displayText = formatNumber(result)
            currentValue = result
        } else {
            storedValue = currentValue
        }

        currentOperation = operation
        shouldResetDisplay = true

        // Update operation text
        if let stored = storedValue {
            operationText = "\(formatNumber(stored)) \(operation.symbol)"
        }
    }

    private func handleEquals() async {
        guard let stored = storedValue, let operation = currentOperation else { return }

        let result = operation.execute(stored, currentValue)
        displayText = formatNumber(result)
        currentValue = result

        // Update operation text to show complete calculation
        operationText = "\(formatNumber(stored)) \(operation.symbol) \(formatNumber(currentValue)) ="

        // Reset for next calculation
        storedValue = nil
        currentOperation = nil
        shouldResetDisplay = true

        // Clear operation text after a delay
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
            await MainActor.run {
                self.operationText = ""
            }
        }
    }

    private func handleClear() async {
        displayText = "0"
        operationText = ""
        currentValue = 0
        storedValue = nil
        currentOperation = nil
        shouldResetDisplay = false
        isNewCalculation = true
    }

    private func handleNegate() async {
        currentValue = -currentValue
        displayText = formatNumber(currentValue)
    }

    private func handlePercent() async {
        currentValue = currentValue / 100
        displayText = formatNumber(currentValue)
    }

    // MARK: - Helper Functions (Pure)
    private func parseDisplayValue(_ text: String) -> Double {
        Double(text) ?? 0
    }

    private func formatNumber(_ value: Double) -> String {
        // Remove trailing zeros and decimal point if not needed
        let formatted = value.truncatingRemainder(dividingBy: 1) == 0
            ? String(format: "%.0f", value)
            : String(format: "%.8f", value)
                .replacingOccurrences(of: #"\.?0+$"#, with: "", options: .regularExpression)

        // Handle scientific notation for very large or small numbers
        if abs(value) >= 1e12 || (abs(value) < 1e-6 && value != 0) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .scientific
            formatter.maximumSignificantDigits = 8
            return formatter.string(from: NSNumber(value: value)) ?? formatted
        }

        // Add thousands separators for readability
        if abs(value) >= 1000 {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 8
            formatter.groupingSeparator = ","
            return formatter.string(from: NSNumber(value: value)) ?? formatted
        }

        return formatted
    }
}
