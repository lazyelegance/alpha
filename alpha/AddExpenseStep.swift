//
//  AddExpenseStep.swift
//  alpha
//
//  Created by Ezra Bathini on 16/07/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import Foundation
import Material

public enum AddExpenseStep {
    case description
    case billAmount
    case parity
    case finish
    
    
    func toString() -> String {
        switch self {
        case .description:
            return "Description"
        case .billAmount:
            return "Bill Amount"
        case parity:
            return "Parity"
        case .finish:
            return "Finish"
        }
    }
    
    func nextStep() -> AddExpenseStep {
        switch self {
        case .description:
            return .billAmount
        case .billAmount:
            return .parity
        case .parity:
            return .finish
        case .finish:
            return self
        }
    }
    
    func mongoField() ->String {
        switch self {
        case .description:
            return "Description"
        case .billAmount:
            return "BillAmount"
        case parity:
            return "parity"
        case .finish:
            return "Finish"
        }
    }
    
    func toColor() -> UIColor {
        switch self {
        case .description:
            return MaterialColor.amber.accent1
        case .billAmount:
            return MaterialColor.deepOrange.accent1
        case .parity:
            return MaterialColor.lightBlue.accent1
        case .finish:
            return  MaterialColor.lightGreen.accent1
        }
    }
    
}
