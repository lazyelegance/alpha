//
//  Expense.swift
//  alpha
//
//  Created by Ezra Bathini on 17/07/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import Foundation

struct Expense {
    //
    
    var description: String
    var billAmount: Float
    var date = String()
    var spent = [String: Int]()
    var settlement = [String: Float]()
    var share = [String: Float]()
    var parity = [String: Int]()
    var addedBy = String()
    var group = String()
    var groupMembers = [String]()
    
    init(desc: String) {
        self.description = desc
        self.billAmount = 0.00
    }
    
}