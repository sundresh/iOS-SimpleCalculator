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
    private var calculator: Calculator?
    /// The display shows numbers entered and calculated
    private var display: UILabel?
    /// The clear button's label can change betwen "AC" and "C"
    private var clearButton: UIButton?
    /// The display and all of the buttons are subviews of our view, with positions in a grid of
    /// squares. For example, (v, row: 1, col: 0, width: 2) means view v occupies the left two
    /// cells of the second row from the top. The maximum values of row and col determine how many
    /// rows and columns there are in the grid.
    private var subviewCoordinates: [(UIView, row: Int, col: Int, width: Int)]

    /// Disable rotation
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get { [ .portrait ] }
    }

    init() {
        subviewCoordinates = []
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // TODO: Move layoutButtons() and buttonCoordinates to a separate struct for a grid of subviews?
    private func layoutGrid() {
        // The max values of row and col determine how many rows and columns there are in the grid.
        let numRows = Double(subviewCoordinates.map { $0.row + 1 }.max() ?? 0)
        let numCols = Double(subviewCoordinates.map { $0.col + 1 }.max() ?? 0)
        // Arbitrary constant for the space between grid cells
        let spacingSize = 7.5
        // Compute the square cell size that will fit in the view
        let cellSize = min(view.frame.width / numCols, view.frame.height / numRows) - spacingSize
        // xOffset or yOffset add any necessary padding to center the grid in the view.
        let xOffset = (view.frame.width - (numCols + 1) * spacingSize - numCols * cellSize) / 2
        let yOffset = (view.frame.height - (numRows + 1) * spacingSize - numRows * cellSize) / 2

        // Lay out all of the subviews
        for (subview, row: row, col: col, width: width) in subviewCoordinates {
            let row = Double(row)
            let col = Double(col)
            let width = Double(width)
            subview.frame = CGRect(
                x: xOffset + (col + 1) * spacingSize + col * cellSize,
                // Note: The first `row` in `y` below should be `(row + 1)` to be consistent
                // with `x` above, but it looks better like this. What that really means is
                // our margin all around should be greater than the spacing between cells.
                y: yOffset + row * spacingSize + row * cellSize,
                width: (width - 1) * spacingSize + width * cellSize,
                height: cellSize)
        }
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
        display?.text = calculator?.displayString
        clearButton?.titleLabel?.text = calculator?.clearButtonLabel
    }

    /// In viewDidLoad() we create all of the subviews, including registering button handlers.
    override func viewDidLoad() {
        calculator = Calculator(flashDisplay: self.flashDisplay)

        // Reusable parameters for creating buttons
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.cornerStyle = .capsule
        buttonConfiguration.baseForegroundColor = .white

        let buttonTitleAttributes = [NSAttributedString.Key.font:
                                        UIFont.systemFont(ofSize: 30, weight: .light)]

        // Function to create a button
        @discardableResult  // We actually only save the result of this function for clearButton.
        func makeButton(title: String, color: UIColor, row: Int, col: Int, width: Int = 1,
                        handler: @escaping () -> Void) -> UIButton {
            // This is the only way I could find to correctly configure the button color.
            buttonConfiguration.baseBackgroundColor = color
            // When the user taps a button, call its handler and then update the display.
            let primaryAction = UIAction(title: title) { action in
                handler()
                self.updateDisplay()
            }
            let button = UIButton(configuration: buttonConfiguration, primaryAction: primaryAction)
            // When initializing a UIButton with a Configuration, we need to use an attributed
            // string in order to control the font/size of the button title label. Separately
            // setting the font/font size on the title label doesn't work in this case.
            button.setAttributedTitle(
                NSAttributedString(string: title, attributes: buttonTitleAttributes), for: .normal)
            button.titleLabel?.textAlignment = .center
            // Add the button as a subview and retain a reference to it.
            view.addSubview(button)
            subviewCoordinates.append((button, row: row, col: col, width: width))
            return button
        }

        // Create the label used to show numbers entered and calculated.
        display = UILabel()
        display?.textAlignment = .right
        display?.font = .systemFont(ofSize: 70, weight: .light)
        // Add the display label as a subview and retain a reference to it.
        view.addSubview(display!)
        subviewCoordinates.append((display!, row: 1, col: 0, width: 4))

        // Create all of the buttons.
        clearButton = makeButton(title: "AC",  color: .systemRed, row: 3, col: 0) {
            self.calculator?.clearButtonHandler()
        }
        makeButton(title: "+/-", color: .systemOrange, row: 3, col: 1) {
            self.calculator?.negateButtonHandler()
        }
        makeButton(title: "%",   color: .systemOrange, row: 3, col: 2) {
            self.calculator?.percentButtonHandler()
        }
        makeButton(title: "/", color: .systemOrange, row: 3, col: 3) {
            self.calculator?.operationButtonHandler(.divide)
        }
        makeButton(title: "*", color: .systemOrange, row: 4, col: 3) {
            self.calculator?.operationButtonHandler(.multiply)
        }
        makeButton(title: "-", color: .systemOrange, row: 5, col: 3) {
            self.calculator?.operationButtonHandler(.subtract)
        }
        makeButton(title: "+", color: .systemOrange, row: 6, col: 3) {
            self.calculator?.operationButtonHandler(.add)
        }
        makeButton(title: "0", color: .systemGray, row: 7, col: 0) {
            self.calculator?.digitButtonHandler(0)
        }
        for n in (1...9) {
            makeButton(title: String(n), color: .systemGray, row: 6 - (n - 1) / 3, col: (n - 1) % 3) {
                self.calculator?.digitButtonHandler(n)
            }
        }
        makeButton(title: ".", color: .systemGray, row: 7, col: 1) {
            self.calculator?.decimalPointButtonHandler()
        }
        makeButton(title: "=", color: .systemCyan, row: 7, col: 2, width: 2) {
            self.calculator?.equalsButtonHandler()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        updateDisplay()
    }

    override func viewWillLayoutSubviews() {
        layoutGrid()
    }
}
