//
//  CalculatorUIView.swift
//  SimpleCalculator
//
//  Created by Sameer Sundresh on 5/9/23.
//

import UIKit

class CalculatorUIView: UIView {
    /// The display and all of the buttons are subviews of our view, with positions in a grid of
    /// squares. For example, (v, row: 1, col: 0, width: 2) means view v occupies the left two
    /// cells of the second row from the top. The maximum values of row and col determine how many
    /// rows and columns there are in the grid.
    private var subviewCoordinates: [(UIView, row: Int, col: Int, width: Int)]

    /// The display shows numbers entered and calculated
    var display: UILabel!
    /// The clear button's label can change betwen "AC" and "C"
    var clearButton: UIButton!
    /// The rest of the buttons are just normal buttons that don't change state
    var negateButton: UIButton!
    var percentButton: UIButton!
    var addButton: UIButton!
    var subtractButton: UIButton!
    var multiplyButton: UIButton!
    var divideButton: UIButton!
    var digitButtons: [UIButton]!
    var decimalPointButton: UIButton!
    var equalsButton: UIButton!

    init() {
        subviewCoordinates = []
        super.init(frame: CGRect())
        loadSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init?(coder:) has not been implemented")
    }

    /// Create all of the subviews: the display and buttons
    private func loadSubviews() {
        // Reusable parameters for creating buttons
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.cornerStyle = .capsule
        buttonConfiguration.baseForegroundColor = .white

        let buttonTitleAttributes = [NSAttributedString.Key.font:
                                        UIFont.systemFont(ofSize: 30, weight: .light)]

        // Function to create a button
        func makeButton(title: String, color: UIColor, row: Int, col: Int, width: Int = 1) -> UIButton {
            // This is the only way I could find to correctly configure the button color.
            buttonConfiguration.baseBackgroundColor = color
            let button = UIButton(configuration: buttonConfiguration)
            // When initializing a UIButton with a Configuration, we need to use an attributed
            // string in order to control the font/size of the button title label. Separately
            // setting the font/font size on the title label doesn't work in this case.
            button.setAttributedTitle(
                NSAttributedString(string: title, attributes: buttonTitleAttributes), for: .normal)
            button.titleLabel?.textAlignment = .center
            // Add the button as a subview and retain a reference to it.
            addSubview(button)
            subviewCoordinates.append((button, row: row, col: col, width: width))
            return button
        }

        // Create the label used to show numbers entered and calculated.
        display = UILabel()
        display?.textAlignment = .right
        display?.font = .systemFont(ofSize: 70, weight: .light)
        // Add the display label as a subview and retain a reference to it.
        addSubview(display!)
        subviewCoordinates.append((display!, row: 1, col: 0, width: 4))

        // Create all of the buttons.
        clearButton = makeButton(title: "AC",  color: .systemRed, row: 3, col: 0)
        negateButton = makeButton(title: "+/-", color: .systemOrange, row: 3, col: 1)
        percentButton = makeButton(title: "%",   color: .systemOrange, row: 3, col: 2)
        divideButton = makeButton(title: "÷", color: .systemOrange, row: 3, col: 3)
        multiplyButton = makeButton(title: "×", color: .systemOrange, row: 4, col: 3)
        subtractButton = makeButton(title: "-", color: .systemOrange, row: 5, col: 3)
        addButton = makeButton(title: "+", color: .systemOrange, row: 6, col: 3)

        var digitButtons: [UIButton] = []
        digitButtons.append(makeButton(title: "0", color: .systemGray, row: 7, col: 0))
        for n in (1...9) {
            digitButtons.append(makeButton(title: String(n), color: .systemGray, row: 6 - (n - 1) / 3, col: (n - 1) % 3))
        }
        self.digitButtons = digitButtons

        decimalPointButton = makeButton(title: ".", color: .systemGray, row: 7, col: 1)
        equalsButton = makeButton(title: "=", color: .systemCyan, row: 7, col: 2, width: 2)

        for (subview, row: _, col: _, width: _) in subviewCoordinates {
            addSubview(subview)
        }
    }

    /// Layout the display and grid of buttons
    override func layoutSubviews() {
        // The max values of row and col determine how many rows and columns there are in the grid.
        let numRows = Double(subviewCoordinates.map { $0.row + 1 }.max() ?? 0)
        let numCols = Double(subviewCoordinates.map { $0.col + 1 }.max() ?? 0)
        // Arbitrary constant for the space between grid cells
        let spacingSize = 7.5
        // Compute the square cell size that will fit in the view
        let cellSize = min(frame.width / numCols, frame.height / numRows) - spacingSize
        // xOffset or yOffset add any necessary padding to center the grid in the view.
        let xOffset = (frame.width - (numCols + 1) * spacingSize - numCols * cellSize) / 2
        let yOffset = (frame.height - (numRows + 1) * spacingSize - numRows * cellSize) / 2

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
}
