//
//  ExpenseType.swift
//  alpha
//
//  Created by Ezra Bathini on 31/07/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import Foundation

public enum ExpenseType {
    case user
    case group
    
    func firstStep() -> Int {
        switch self {
        case .user:
            return 1
        case .group:
            return 2
        }
    }
}