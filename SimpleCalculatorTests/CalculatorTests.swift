//
//  CalculatorTests.swift
//  my-ios-calculator-appTests
//
//  Created by Sameer Sundresh on 5/3/23.
//

import XCTest
@testable import SimpleCalculator

final class CalculatorTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitialDisplay() throws {
        let c = Calculator()
        XCTAssertEqual(c.displayString, "0")
    }

    private func enterDigits(_ c: inout Calculator, _ digits: [Int]) {
        for d in digits {
            c.digitButtonHandler(d)
        }
    }

    private func enterNumber(_ c: inout Calculator, _ number: String) {
        for d in number {
            switch d {
            case "-":
                c.negateButtonHandler()
            case ".":
                c.decimalPointButtonHandler()
            default:
                c.digitButtonHandler(Int(String(d))!)
            }
        }
    }

    func testInitialNumberEntry() throws {
        var c = Calculator()
        c.negateButtonHandler()
        XCTAssertEqual(c.displayString, "-0")
        c.negateButtonHandler()
        enterDigits(&c, [0, 0, 0])
        XCTAssertEqual(c.displayString, "0")
        c.negateButtonHandler()
        XCTAssertEqual(c.displayString, "-0")
        c.negateButtonHandler()
        XCTAssertEqual(c.displayString, "0")
        c.digitButtonHandler(1)
        XCTAssertEqual(c.displayString, "1")
        enterDigits(&c, [2, 3, 4])
        XCTAssertEqual(c.displayString, "1234")
        c.negateButtonHandler()
        XCTAssertEqual(c.displayString, "-1234")
        c.negateButtonHandler()
        XCTAssertEqual(c.displayString, "1234")
        c.decimalPointButtonHandler()
        XCTAssertEqual(c.displayString, "1234.")
        c.negateButtonHandler()
        XCTAssertEqual(c.displayString, "-1234.")
        c.negateButtonHandler()
        XCTAssertEqual(c.displayString, "1234.")
        c.digitButtonHandler(5)
        XCTAssertEqual(c.displayString, "1234.5")
        enterDigits(&c, [6, 7, 8])
        XCTAssertEqual(c.displayString, "1234.5678")
        enterDigits(&c, [0, 0, 0])
        XCTAssertEqual(c.displayString, "1234.5678000")
        c.negateButtonHandler()
        XCTAssertEqual(c.displayString, "-1234.5678000")
    }

    func testPositiveInitialNumberEntryFollowedByAnOperation() throws {
        var c = Calculator()
        enterDigits(&c, [1, 2, 3, 4])
        XCTAssertEqual(c.displayString, "1234")
        c.decimalPointButtonHandler()
        XCTAssertEqual(c.displayString, "1234.")
        enterDigits(&c, [5, 6, 7, 8, 0, 0, 0])
        XCTAssertEqual(c.displayString, "1234.5678000")
        c.operationButtonHandler(.add)
        XCTAssertEqual(c.displayString, "1234.5678")
    }

    func testNegativeInitialNumberEntryFollowedByAnOperation() throws {
        var c = Calculator()
        enterDigits(&c, [1, 2, 3, 4])
        XCTAssertEqual(c.displayString, "1234")
        c.negateButtonHandler()
        XCTAssertEqual(c.displayString, "-1234")
        c.decimalPointButtonHandler()
        XCTAssertEqual(c.displayString, "-1234.")
        enterDigits(&c, [5, 6, 7, 8, 0, 0, 0])
        XCTAssertEqual(c.displayString, "-1234.5678000")
        c.operationButtonHandler(.add)
        XCTAssertEqual(c.displayString, "-1234.5678")
    }

    func testPositiveIntegerAddition() throws {
        var c = Calculator()
        c.digitButtonHandler(2)
        c.operationButtonHandler(.add)
        c.digitButtonHandler(3)
        c.equalsButtonHandler()
        XCTAssertEqual(c.displayString, "5")
        c.operationButtonHandler(.add)
        XCTAssertEqual(c.displayString, "5")
        c.digitButtonHandler(4)
        XCTAssertEqual(c.displayString, "4")
        c.operationButtonHandler(.add)
        XCTAssertEqual(c.displayString, "9")
        c.digitButtonHandler(4)
        c.operationButtonHandler(.add)
        XCTAssertEqual(c.displayString, "13")
    }

    func testPositiveFractionAddition() throws {
        var c = Calculator()
        c.digitButtonHandler(2)
        c.decimalPointButtonHandler()
        c.digitButtonHandler(3)
        c.operationButtonHandler(.add)
        c.digitButtonHandler(4)
        c.decimalPointButtonHandler()
        c.digitButtonHandler(5)
        c.equalsButtonHandler()
        XCTAssertEqual(c.displayString, "6.8")
    }

    func testPositiveFractionLessThanOneAddition() throws {
        var c = Calculator()
        c.decimalPointButtonHandler()
        XCTAssertEqual(c.displayString, "0.")
        c.digitButtonHandler(1)
        XCTAssertEqual(c.displayString, "0.1")
        c.operationButtonHandler(.add)
        c.decimalPointButtonHandler()
        XCTAssertEqual(c.displayString, "0.")
        c.digitButtonHandler(2)
        XCTAssertEqual(c.displayString, "0.2")
        c.equalsButtonHandler()
        XCTAssertEqual(c.displayString, "0.3")
    }

    func testPositiveSelfAddition() throws {
        var c = Calculator()
        enterDigits(&c, [1, 2, 3, 4])
        c.decimalPointButtonHandler()
        enterDigits(&c, [5, 6, 7, 8, 0, 0, 0])
        c.operationButtonHandler(.add)
        c.equalsButtonHandler()
        XCTAssertEqual(c.displayString, "2469.1356")
    }

    func testInitialResetButtonLabel() throws {
        let c = Calculator()
        XCTAssertEqual(c.clearButtonLabel, "AC")
    }

    func testResetButtonAfterOneNumber() throws {
        var c = Calculator()
        XCTAssertEqual(c.clearButtonLabel, "AC")
        c.digitButtonHandler(1)
        XCTAssertEqual(c.displayString, "1")
        XCTAssertEqual(c.clearButtonLabel, "C")
        c.clearButtonHandler()
        XCTAssertEqual(c.displayString, "0")
        XCTAssertEqual(c.clearButtonLabel, "AC")
    }

    func testResetButtonAfterOneNumberAndOneOperation() throws {
        var c = Calculator()
        XCTAssertEqual(c.clearButtonLabel, "AC")
        c.digitButtonHandler(1)
        XCTAssertEqual(c.displayString, "1")
        XCTAssertEqual(c.clearButtonLabel, "C")
        c.operationButtonHandler(.add)
        XCTAssertEqual(c.displayString, "1")
        XCTAssertEqual(c.clearButtonLabel, "C")
        c.clearButtonHandler()
        XCTAssertEqual(c.displayString, "0")
        XCTAssertEqual(c.clearButtonLabel, "AC")
    }

    func testResetButtonAfterTwoNumbers() throws {
        var c = Calculator()
        XCTAssertEqual(c.clearButtonLabel, "AC")
        c.digitButtonHandler(1)
        XCTAssertEqual(c.displayString, "1")
        XCTAssertEqual(c.clearButtonLabel, "C")
        c.operationButtonHandler(.add)
        XCTAssertEqual(c.displayString, "1")
        XCTAssertEqual(c.clearButtonLabel, "C")
        c.digitButtonHandler(2)
        XCTAssertEqual(c.displayString, "2")
        XCTAssertEqual(c.clearButtonLabel, "C")
        c.clearButtonHandler()
        XCTAssertEqual(c.displayString, "0")
        XCTAssertEqual(c.clearButtonLabel, "AC")
        c.equalsButtonHandler()
        XCTAssertEqual(c.displayString, "1")
        XCTAssertEqual(c.clearButtonLabel, "AC")
    }

    func testResetButtonAfterEnteringSecondNumberAsZero() throws {
        var c = Calculator()
        XCTAssertEqual(c.clearButtonLabel, "AC")
        c.digitButtonHandler(1)
        XCTAssertEqual(c.displayString, "1")
        XCTAssertEqual(c.clearButtonLabel, "C")
        c.operationButtonHandler(.add)
        XCTAssertEqual(c.displayString, "1")
        XCTAssertEqual(c.clearButtonLabel, "C")
        c.digitButtonHandler(0)
        XCTAssertEqual(c.displayString, "0")
        XCTAssertEqual(c.clearButtonLabel, "C")
        c.clearButtonHandler()
        XCTAssertEqual(c.displayString, "0")
        XCTAssertEqual(c.clearButtonLabel, "AC")
        c.equalsButtonHandler()
        XCTAssertEqual(c.displayString, "1")
        XCTAssertEqual(c.clearButtonLabel, "AC")
    }

    func testResetButtonAfterOneFullCalculation() throws {
        var c = Calculator()
        XCTAssertEqual(c.clearButtonLabel, "AC")
        c.digitButtonHandler(1)
        XCTAssertEqual(c.displayString, "1")
        XCTAssertEqual(c.clearButtonLabel, "C")
        c.operationButtonHandler(.add)
        XCTAssertEqual(c.displayString, "1")
        XCTAssertEqual(c.clearButtonLabel, "C")
        c.digitButtonHandler(2)
        XCTAssertEqual(c.displayString, "2")
        XCTAssertEqual(c.clearButtonLabel, "C")
        c.equalsButtonHandler()
        XCTAssertEqual(c.displayString, "3")
        XCTAssertEqual(c.clearButtonLabel, "C")
        c.clearButtonHandler()
        XCTAssertEqual(c.displayString, "0")
        XCTAssertEqual(c.clearButtonLabel, "AC")
        c.equalsButtonHandler()
        XCTAssertEqual(c.displayString, "2")
        XCTAssertEqual(c.clearButtonLabel, "AC")
    }

    func testResetButtonLabelAfterOneMinusOne() throws {
        var c = Calculator()
        XCTAssertEqual(c.clearButtonLabel, "AC")
        c.digitButtonHandler(1)
        XCTAssertEqual(c.displayString, "1")
        XCTAssertEqual(c.clearButtonLabel, "C")
        c.operationButtonHandler(.subtract)
        c.equalsButtonHandler()
        XCTAssertEqual(c.displayString, "0")
        XCTAssertEqual(c.clearButtonLabel, "C")
    }

    func testNegateAfterCalculation() throws {
        var c = Calculator()
        c.digitButtonHandler(1)
        c.operationButtonHandler(.add)
        c.digitButtonHandler(1)
        c.equalsButtonHandler()
        c.negateButtonHandler()
        XCTAssertEqual(c.displayString, "-2")
    }

    func testNegateBeforeAndAfterAllClear() throws {
        var c = Calculator()
        c.negateButtonHandler()
        XCTAssertEqual(c.displayString, "-0")
        c.digitButtonHandler(1)
        XCTAssertEqual(c.displayString, "-1")
        XCTAssertEqual(c.clearButtonLabel, "C")
        c.clearButtonHandler()
        XCTAssertEqual(c.displayString, "0")
        XCTAssertEqual(c.clearButtonLabel, "AC")
        c.clearButtonHandler()
        XCTAssertEqual(c.displayString, "0")
        XCTAssertEqual(c.clearButtonLabel, "AC")
        c.negateButtonHandler()
        XCTAssertEqual(c.displayString, "-0")
    }

    func testMiscOperations() throws {
        var c = Calculator()
        enterNumber(&c, "123.45")
        XCTAssertEqual(c.displayString, "123.45")
        c.operationButtonHandler(.add)
        enterNumber(&c, "-56.789")
        XCTAssertEqual(c.displayString, "-56.789")
        c.operationButtonHandler(.subtract)
        XCTAssertEqual(c.displayString, "66.661")
        enterNumber(&c, ".2222")
        XCTAssertEqual(c.displayString, "0.2222")
        c.operationButtonHandler(.multiply)
        XCTAssertEqual(c.displayString, "66.4388")
        enterNumber(&c, "-90.564")
        XCTAssertEqual(c.displayString, "-90.564")
        c.operationButtonHandler(.divide)
        XCTAssertEqual(c.displayString, "-6016.9634832")
        enterNumber(&c, "4.5")
        XCTAssertEqual(c.displayString, "4.5")
        c.equalsButtonHandler()
        XCTAssertEqual(c.displayString, "-1337.1029962667")
        c.equalsButtonHandler()
        XCTAssertEqual(c.displayString, "-297.1339991704")
        c.negateButtonHandler()
        XCTAssertEqual(c.displayString, "297.1339991704")
    }

    func testInitialNumberPercent() throws {
        var c = Calculator()
        enterNumber(&c, "12")
        c.percentButtonHandler()
        XCTAssertEqual(c.displayString, "0.12")
    }

    func testInitialNumberPlusSelfAsPercent() throws {
        var c = Calculator()
        enterNumber(&c, "12")
        c.operationButtonHandler(.add)
        c.percentButtonHandler()
        c.equalsButtonHandler()
        XCTAssertEqual(c.displayString, "12.12")
    }

    func testResultAsPercent() throws {
        var c = Calculator()
        c.digitButtonHandler(4)
        c.operationButtonHandler(.add)
        c.digitButtonHandler(5)
        c.equalsButtonHandler()
        c.percentButtonHandler()
        XCTAssertEqual(c.displayString, "0.09")
    }

    func testReplacingInitialNumberAsPercent() throws {
        var c = Calculator()
        c.digitButtonHandler(2)
        c.percentButtonHandler()
        XCTAssertEqual(c.displayString, "0.02")
        c.digitButtonHandler(3)
        c.equalsButtonHandler()
        XCTAssertEqual(c.displayString, "3")
    }

    func testReplacingArgumentAsPercent() throws {
        var c = Calculator()
        c.digitButtonHandler(2)
        XCTAssertEqual(c.displayString, "2")
        c.operationButtonHandler(.add)
        c.digitButtonHandler(3)
        c.percentButtonHandler()
        XCTAssertEqual(c.displayString, "0.03")
        c.digitButtonHandler(4)
        XCTAssertEqual(c.displayString, "4")
        c.equalsButtonHandler()
        XCTAssertEqual(c.displayString, "6")
    }

    func testNegatingArgPercent() throws {
        var c = Calculator()
        c.digitButtonHandler(1)
        c.operationButtonHandler(.add)
        c.digitButtonHandler(2)
        c.percentButtonHandler()
        c.negateButtonHandler()
        c.equalsButtonHandler()
        XCTAssertEqual(c.displayString, "0.98")
    }

    func testAtMostOneDecimalPoint() throws {
        var numDisplayFlashes = 0
        var c = Calculator(flashDisplay: { numDisplayFlashes += 1 })
        XCTAssertEqual(c.displayString, "0")
        c.decimalPointButtonHandler()
        XCTAssertEqual(c.displayString, "0.")
        XCTAssertEqual(numDisplayFlashes, 0)
        c.decimalPointButtonHandler()
        XCTAssertEqual(c.displayString, "0.")
        XCTAssertEqual(numDisplayFlashes, 1)
        c.digitButtonHandler(1)
        XCTAssertEqual(c.displayString, "0.1")
        c.decimalPointButtonHandler()
        XCTAssertEqual(c.displayString, "0.1")
        XCTAssertEqual(numDisplayFlashes, 2)
        c.digitButtonHandler(2)
        c.decimalPointButtonHandler()
        c.decimalPointButtonHandler()
        c.decimalPointButtonHandler()
        c.digitButtonHandler(3)
        c.decimalPointButtonHandler()
        c.decimalPointButtonHandler()
        c.decimalPointButtonHandler()
        XCTAssertEqual(c.displayString, "0.123")
        XCTAssertEqual(numDisplayFlashes, 8)
    }
}
