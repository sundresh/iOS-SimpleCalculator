//
//  CalculatorView.swift
//  SimpleCalculator
//
//  Created by Sameer Sundresh on 5/2/23.
//

import SwiftUI

/// SwiftUI View that displays a simple calculator
struct CalculatorView: View {
    /// Create a button in our custom style for the calculator
    private func button(_ title: String, color: Color = .gray, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.title2)
                .bold()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity)
                .background(color, in: Capsule())
        }
    }

    /// The calculator struct does the actual calculation
    @State private var calculator: Calculator
    /// The textOpacity object is used to animate (flash) the display with SwiftUI. This is an
    /// object rather than a struct so that we can pass a reference to it when calling the
    /// Calculator initializer from the CalculatorView initializer.
    @ObservedObject private var textOpacity: ObservableValue<Double>

    init() {
        let textOpacity = ObservableValue<Double>(1.0)
        self.textOpacity = textOpacity
        self.calculator = Calculator(flashDisplay: {
            // Momentarily animate textOpacity down to 0 to flash the display
            withAnimation(.easeIn(duration: 0.05)) {
                textOpacity.value = 0.0
            }
            withAnimation(.easeOut(duration: 0.05).delay(0.1)) {
                textOpacity.value = 1.0
            }
        })
    }

    var body: some View {
        Grid {
            // Calculator display goes at the top
            Text(calculator.displayString)
                .font(.largeTitle)
                .foregroundColor(.white)
                .opacity(textOpacity.value)
                .padding(10)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
            // Followed by rows of buttons
            GridRow {
                button(calculator.clearButtonLabel, color: .red) { calculator.clearButtonHandler() }
                button("+/-", color: .orange) { calculator.negateButtonHandler() }
                button("%", color: .orange) { calculator.percentButtonHandler() }
                button("÷", color: .orange) { calculator.operationButtonHandler(.divide) }
            }
            GridRow {
                button("7") { calculator.digitButtonHandler(7) }
                button("8") { calculator.digitButtonHandler(8) }
                button("9") { calculator.digitButtonHandler(9) }
                button("×", color: .orange) { calculator.operationButtonHandler(.multiply) }
            }
            GridRow {
                button("4") { calculator.digitButtonHandler(4) }
                button("5") { calculator.digitButtonHandler(5) }
                button("6") { calculator.digitButtonHandler(6) }
                button("-", color: .orange) { calculator.operationButtonHandler(.subtract) }
            }
            GridRow {
                button("1") { calculator.digitButtonHandler(1) }
                button("2") { calculator.digitButtonHandler(2) }
                button("3") { calculator.digitButtonHandler(3) }
                button("+", color: .orange) { calculator.operationButtonHandler(.add) }
            }
            GridRow {
                button("0") { calculator.digitButtonHandler(0) }
                button(".") { calculator.decimalPointButtonHandler() }
                button("=", color: .cyan) { calculator.equalsButtonHandler() }
                    .gridCellColumns(2)  // "=" button is double-wide
            }
        }.gridCellUnsizedAxes(.vertical).padding(.all).background(.black)
    }
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView()
    }
}

