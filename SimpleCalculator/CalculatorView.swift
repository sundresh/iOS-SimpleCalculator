//
//  CalculatorView.swift
//  SimpleCalculator
//
//  Created by Sameer Sundresh on 5/2/23.
//

import SwiftUI

/// SwiftUI View that displays a simple calculator
struct CalculatorView: View {
    /// The calculator struct does the actual calculation
    @ObservedObject private var calculator: Calculator
    /// The textOpacity object is used to animate (flash) the display with SwiftUI. This is an
    /// object rather than a struct so that we can pass a reference to it when calling the
    /// Calculator initializer from the CalculatorView initializer.
    @ObservedObject private var textOpacity: ObservableValue<Double>

    /// Create a button in our custom style for the calculator
    struct ButtonBuilder {
        private let geometryProxy: GeometryProxy

        init(geometryProxy: GeometryProxy) {
            self.geometryProxy = geometryProxy
        }

        func buildButton(_ title: String, color: Color = .gray, width: Double = 1, action: @escaping () -> Void) -> some View {
            let buttonSize = min(geometryProxy.size.height / 7, (geometryProxy.size.width - 3*15) / 4)
            return Button(action: action) {
                Text(title)
                    .font(Font.system(size: 30, weight: .light))
                    .bold()
                    .foregroundColor(.white)
                    .frame(maxWidth: width * buttonSize + 15 * (width - 1),
                           maxHeight: buttonSize)
                    .background(color, in: Capsule())
            }
        }
    }

    init(calculator: Calculator) {
        let textOpacity = ObservableValue<Double>(1.0)
        self.textOpacity = textOpacity
        self.calculator = calculator
        self.calculator.flashDisplay = {
            // Momentarily animate textOpacity down to 0 to flash the display
            withAnimation(.easeIn(duration: 0.05)) {
                textOpacity.value = 0.0
            }
            withAnimation(.easeOut(duration: 0.05).delay(0.1)) {
                textOpacity.value = 1.0
            }
        }
    }

    func getCalculator() -> Calculator {
        return calculator
    }

    var body: some View {
        GeometryReader { geometryProxy in
            let bb = ButtonBuilder(geometryProxy: geometryProxy)
            Grid {
                // Calculator display goes at the top
                Text(calculator.displayString)
                    .font(Font.system(size: 70, weight: .light))
                    .foregroundColor(.white)
                    .opacity(textOpacity.value)
                    .padding(10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                // Followed by rows of buttons
                GridRow {
                    bb.buildButton(calculator.clearButtonLabel, color: .red) { calculator.clearButtonHandler() }
                    bb.buildButton("+/-", color: .orange) { calculator.negateButtonHandler() }
                    bb.buildButton("%", color: .orange) { calculator.percentButtonHandler() }
                    bb.buildButton("÷", color: .orange) { calculator.operationButtonHandler(.divide) }
                }
                GridRow {
                    bb.buildButton("7") { calculator.digitButtonHandler(7) }
                    bb.buildButton("8") { calculator.digitButtonHandler(8) }
                    bb.buildButton("9") { calculator.digitButtonHandler(9) }
                    bb.buildButton("×", color: .orange) { calculator.operationButtonHandler(.multiply) }
                }
                GridRow {
                    bb.buildButton("4") { calculator.digitButtonHandler(4) }
                    bb.buildButton("5") { calculator.digitButtonHandler(5) }
                    bb.buildButton("6") { calculator.digitButtonHandler(6) }
                    bb.buildButton("-", color: .orange) { calculator.operationButtonHandler(.subtract) }
                }
                GridRow {
                    bb.buildButton("1") { calculator.digitButtonHandler(1) }
                    bb.buildButton("2") { calculator.digitButtonHandler(2) }
                    bb.buildButton("3") { calculator.digitButtonHandler(3) }
                    bb.buildButton("+", color: .orange) { calculator.operationButtonHandler(.add) }
                }
                GridRow {
                    bb.buildButton("0") { calculator.digitButtonHandler(0) }
                    bb.buildButton(".") { calculator.decimalPointButtonHandler() }
                    bb.buildButton("=", color: .cyan, width: 2) { calculator.equalsButtonHandler() }
                        .gridCellColumns(2)  // "=" button is double-wide
                }
            }.gridCellUnsizedAxes(.vertical).padding(.all).background(.black)
        }
    }
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView(calculator: Calculator())
    }
}

