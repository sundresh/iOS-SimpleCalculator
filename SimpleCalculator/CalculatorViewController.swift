//
//  CalculatorViewController.swift
//  SimpleCalculator
//
//  Created by Sameer Sundresh on 5/6/23.
//

import UIKit

/// View Controller for a simple calculator
class CalculatorViewController: UIViewController {
    /// The calculator struct does the actual calculation
    var calculator: Calculator
    /// The display shows numbers entered and calculated
    private weak var display: UILabel?
    /// The clear button's label can change betwen "AC" and "C"
    private weak var clearButton: UIButton?
    /// The display and all of the buttons are subviews of our view, with positions in a grid of
    /// squares. For example, (v, row: 1, col: 0, width: 2) means view v occupies the left two
    /// cells of the second row from the top. The maximum values of row and col determine how many
    /// rows and columns there are in the grid.
    private var subviewCoordinates: [(UIView, row: Int, col: Int, width: Int)]

    /// Disable rotation
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get { [ .portrait ] }
    }

    init(calculator: Calculator) {
        self.calculator = calculator
        subviewCoordinates = []
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init?(coder:) has not been implemented")
    }

    /// Load the view: a CalculatorUIView
    override func loadView() {
        self.view = CalculatorUIView()
    }

    /// Flash the display, i.e., momentarily make it blank to indicate an error or AC.
    private func flashDisplay() {
        UIView.animate(withDuration: 0.05, delay: 0.0, options: [.curveEaseIn]) {
            self.display?.layer.opacity = 0.0
        }
        UIView.animate(withDuration: 0.05, delay: 0.1, options: [.curveEaseOut]) {
            self.display?.layer.opacity = 1.0
        }
    }

    /// Update the contents of the display and the label of the AC/C button.
    private func updateDisplay() {
        display?.text = calculator.displayString
        clearButton?.titleLabel?.text = calculator.clearButtonLabel
    }

    /// Helper for viewDidLoad() used to register a handler with a UIButton
    private func addButtonHandler(button: UIButton?, handler: @escaping () -> Void) {
        let primaryAction = UIAction(title: button?.currentTitle ?? "") { action in
            handler()
            self.updateDisplay()
        }
        button?.addAction(primaryAction, for: UIControl.Event.primaryActionTriggered)
    }

    /// Attach handlers to buttons and retain references to subviews we need to update later.
    override func viewDidLoad() {
        calculator.flashDisplay = flashDisplay
        if let view = view as? CalculatorUIView {
            display = view.display
            clearButton = view.clearButton
            addButtonHandler(button: view.clearButton) { self.calculator.clearButtonHandler() }
            addButtonHandler(button: view.negateButton) { self.calculator.negateButtonHandler() }
            addButtonHandler(button: view.percentButton) { self.calculator.percentButtonHandler() }
            addButtonHandler(button: view.addButton) { self.calculator.operationButtonHandler(.add) }
            addButtonHandler(button: view.subtractButton) { self.calculator.operationButtonHandler(.subtract) }
            addButtonHandler(button: view.multiplyButton) { self.calculator.operationButtonHandler(.multiply) }
            addButtonHandler(button: view.divideButton) { self.calculator.operationButtonHandler(.divide) }
            for i in 0...9 {
                addButtonHandler(button: view.digitButtons?[i]) { self.calculator.digitButtonHandler(i) }
            }
            addButtonHandler(button: view.decimalPointButton) { self.calculator.decimalPointButtonHandler() }
            addButtonHandler(button: view.equalsButton) { self.calculator.equalsButtonHandler() }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        // Initialize the display
        updateDisplay()
    }
}
