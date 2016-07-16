//
//  AddExpenseStep.swift
//  alpha
//
//  Created by Ezra Bathini on 16/07/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import Foundation

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
    
}
