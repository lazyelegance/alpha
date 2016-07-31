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
    case category
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
        case .category:
            return "Category"
        }
    }
    
    
    
    func nextStep() -> AddExpenseStep {
        switch self {
        case .description:
            return .billAmount
        case .billAmount:
            return .category
        case .parity:
            return .finish
        case .category:
            return .finish
        case .finish:
            return self
        }
    }
    
    func nextGroupExpenseStep() -> AddExpenseStep {
        switch self {
        case .description:
            return .billAmount
        case .billAmount:
            return .parity
        case .parity:
            return .finish
        case .category:
            return .parity
        case .finish:
            return self
        }
    }
    

    
    func toColor() -> UIColor {
        switch self {
        case .description:
            return MaterialColor.blue.darken4
        case .billAmount:
            return MaterialColor.deepOrange.darken1
        case .parity:
            return MaterialColor.blue.darken1
        case .finish:
            return  MaterialColor.indigo.darken1
        case .category:
            return MaterialColor.blueGrey.darken1
        }
    }
    
}
