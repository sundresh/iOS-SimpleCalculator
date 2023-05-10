//
//  SimpleCalculatorApp.swift
//  SimpleCalculator
//
//  Created by Sameer Sundresh on 5/2/23.
//

import SwiftUI

// NOTE: This is no longer used
//@main
struct SimpleCalculatorApp: App {
    var body: some Scene {
        WindowGroup {
            CalculatorView(calculator: Calculator())
        }
    }
}
