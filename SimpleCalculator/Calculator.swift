//
//  CalculatorEngine.swift
//  SimpleCalculator
//
//  Created by Sameer Sundresh on 5/3/23.
//

import Foundation

/// Calculator implements the actual calculator state and behavior.
struct Calculator  {
    /// The basic arithmetic operations supported by our calculator
    enum Operation {
        case add
        case subtract
        case multiply
        case divide
    }

    /// The calculator has two registers: the accumulator, which is both the first argument to an
    /// operation and the destination for calculation results, and the argument register, which is
    /// the second argument to an operation)
    private enum RegisterId {
        case accumulator
        case argument
    }

    private let flashDisplay: () -> Void

    private var enteredNumberSinceLastReset = false
    private var accumulator: Double = 0.0
    private var operation: Operation = .add
    private var argument: Double = 0.0
    private var activeRegisterId: RegisterId = .accumulator
    private var entryBuffer: CalculatorEntryBuffer
    private var negateShouldBeginEditing = true
    private var isEditing: Bool = false {
        willSet(willBeEditing) {
            // Clear the entry buffer when we start editing.
            if !isEditing && willBeEditing {
                entryBuffer.clear()
            }
            negateShouldBeginEditing = false
        }
    }

    init() {
        self.flashDisplay = { }
        self.entryBuffer = CalculatorEntryBuffer(onError: flashDisplay)
    }

    init(flashDisplay: @escaping () -> Void) {
        self.flashDisplay = flashDisplay
        self.entryBuffer = CalculatorEntryBuffer(onError: flashDisplay)
    }

    /// We convert -0.0 to 0.0 when writing to registers because -0.0 is confusing: these two
    /// values are printed differently but compare as equal according to ==.
    private static func convertNegativeZeroToZero(_ number: Double) -> Double {
        if (number == 0) && (number.sign == .minus) {
            return 0.0
        } else {
            return number
        }
    }

    /// Property for accessing the active register.
    /// See RegisterId for an explanation of the Calculator's two registers.
    private var activeRegisterContents: Double {
        get {
            switch activeRegisterId {
            case .accumulator:
                return accumulator
            case .argument:
                return argument
            }
        }
        set {
            switch activeRegisterId {
            case .accumulator:
                accumulator = Calculator.convertNegativeZeroToZero(newValue)
            case .argument:
                argument = Calculator.convertNegativeZeroToZero(newValue)
            }
        }
    }

    /// doAllClear() completely resets the Calculator to its initial state.
    private mutating func doAllClear() {
        enteredNumberSinceLastReset = false
        accumulator = 0.0
        operation = .add
        argument = 0.0
        activeRegisterId = .accumulator
        entryBuffer.clear()
        isEditing = false
        // Important: Set negateShouldBeginEditing after isEditing because setting isEditing
        // clears negateShouldBeginEditing
        negateShouldBeginEditing = true
    }

    /// The rules behind (C) vs. (AC) are:
    /// 1. Initially the clear button reads (AC)
    /// 2. If you hit (C), then the claer button reads (AC) until you start entering a number.
    private var clearButtonLabelIsAC: Bool {
        return !enteredNumberSinceLastReset
    }

    var clearButtonLabel: String {
        if clearButtonLabelIsAC {
            return "AC"
        } else {
            return "C"
        }
    }

    /// Implements the (C) - clear current register or (AC) - all clear buttons.
    mutating func clearButtonHandler() {
        if clearButtonLabelIsAC {
            doAllClear()
            // Flash the display to let the user know that we performed an all clear.
            flashDisplay()
        } else {
            entryBuffer.clear()
            activeRegisterContents = entryBuffer.number
        }
        enteredNumberSinceLastReset = false
    }

    /// Actually performs a calculation.
    private mutating func calculate() {
        isEditing = false
        switch operation {
        case .add:
            accumulator = accumulator + argument
        case .subtract:
            accumulator = accumulator - argument
        case .multiply:
            accumulator = accumulator * argument
        case .divide:
            accumulator = accumulator / argument
        }
        activeRegisterId = .accumulator
    }

    /// Implements the (=) button, which just performs a calculation. You can press (=) repeatedly
    /// to perform the same operation with the latest value of the accumulator and the last-entered
    /// value of the argument register.
    ///
    /// For example, entering "1+1===" results in 4 (start with 1 and add 1 3 times).
    mutating func equalsButtonHandler() {
        calculate()
    }

    /// Implements the (0)-(9) buttons, which just insert digits in the entry buffer.
    mutating func digitButtonHandler(_ digit: Int) {
        isEditing = true
        entryBuffer.enterDigit(digit)
        activeRegisterContents = entryBuffer.number
        enteredNumberSinceLastReset = true
    }

    /// Implements the (.) button, which just inserts a decimal point in the entry buffer.
    mutating func decimalPointButtonHandler() {
        isEditing = true
        entryBuffer.enterDecimalPoint()
        activeRegisterContents = entryBuffer.number
        enteredNumberSinceLastReset = true
    }

    /// Implements the (+), (-), (\*) and (/) buttons. We do not implement any fancy order of
    /// operations: if there is another calculation that was already underway, we complete that
    /// calculation and then use it as the first argument to the new operation.
    mutating func operationButtonHandler(_ operation: Operation) {
        if isEditing && activeRegisterId == .argument {
            calculate()
        }
        isEditing = false
        self.operation = operation
        argument = accumulator
        activeRegisterId = .argument
        // See negateButtonHandler() for info about negateShouldBeginEditing.
        negateShouldBeginEditing = true
    }

    /// Implements the (+/-) button, which negates the currently displayed register. This has one
    /// quirk: You can negate a value you are editng or the result of an operation. But if you just
    /// pressed an operation button, then (+/-) does not negate the displayed value (which is the
    /// value from before pressing an operation button). Rather, this will be interpreted as negative
    /// sign starting the entry of a new number.
    mutating func negateButtonHandler() {
        if negateShouldBeginEditing {
            isEditing = true
        }
        if isEditing {
            entryBuffer.negate()
            activeRegisterContents = entryBuffer.number
            enteredNumberSinceLastReset = true
        } else {
            activeRegisterContents = -activeRegisterContents
        }
    }

    /// Implement the (%) button, which divides the currently displayed register by 100.
    mutating func percentButtonHandler() {
        isEditing = false
        activeRegisterContents = activeRegisterContents / 100
    }

    /// displayNumberFormatter is used in displayString()
    private let displayNumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumIntegerDigits = 1
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 10
        return numberFormatter
    }()

    /// Return a String representation of the calculator's display
    var displayString: String {
        let displayString: String
        if isEditing {
            displayString = entryBuffer.description
        } else {
            displayString = displayNumberFormatter.string(from: NSNumber(value: activeRegisterContents))!
        }
        return displayString
    }
}

