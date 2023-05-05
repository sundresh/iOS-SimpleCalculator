//
//  CalculatorEntry.swift
//  SimpleCalculator
//
//  Created by Sameer Sundresh on 5/2/23.
//

import Foundation

/// A CalculatorEntryBuffer is used to collect user input of a number. It primarily represents the
/// user input as a String, along with some additional flags.
struct CalculatorEntryBuffer: CustomStringConvertible {
    /// numberString contains the digits and decimal point the user has entered.
    private var numberString: String = ""
    /// isNegative is a flag (rather than part of numberString) to make it easy to implement +/-
    private var isNegative: Bool = false
    /// hasDecimalPoint keeps track of whether a decimal point has already been entered, so we can
    /// indicate an error if the user tries to enter an extra decimal point.
    private var hasDecimalPoint: Bool = false
    /// errorHandler is called if the user tries to enter an extra decimal point.
    private let errorHandler: () -> Void

    init(onError errorHandler: @escaping () -> Void) {
        self.errorHandler = errorHandler
    }

    mutating func clear() {
        isNegative = false
        hasDecimalPoint = false
        numberString = ""
    }

    mutating func enterDigit(_ digit: Int) {
        // Don't retain leading zeroes.
        if numberString == "0" {
            numberString = String(digit)
        } else {
            numberString.append(String(digit))
        }
    }

    mutating func enterDecimalPoint() {
        if !hasDecimalPoint {
            // Ensure one leading zero before the decimal point.
            if numberString.isEmpty {
                numberString.append("0")
            }
            numberString.append(".")
            hasDecimalPoint = true
        } else {
            // Don't allow more than one decimal point.
            errorHandler()
        }
    }

    mutating func negate() {
        isNegative = !isNegative
    }

    var isEmpty: Bool {
        // isEmpty is true when the state is equal to the initial or post-clear() state.
        return !isNegative && !hasDecimalPoint && numberString.isEmpty
    }

    /// Convert the contents of the CalculatorEntryBuffer to a String for display.
    var description: String {
        var description = numberString
        if numberString.isEmpty {
            description = "0"
        }
        if isNegative {
            return "-" + description
        } else {
            return description
        }
    }

    /// Convert the contents of the CalculatorEntryBuffer to a number we can calculate with.
    var number: Double {
        if let number = Double(description) {
            return number
        } else {
            return 0.0
        }
    }
}

