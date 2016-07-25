//
//  Expense.swift
//  alpha
//
//  Created by Ezra Bathini on 25/07/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import Foundation
import FirebaseDatabase


struct Expense {
    var expenseId = String()
    var description: String
    var billAmount: Float
    var dateAdded = String()
    var category = String()
    var firebaseDBRef = FIRDatabaseReference()
    
    init() {
        self.description = "New User Expense"
        self.billAmount = 0.00
    }
    
    static func expensesFromResults(results: NSDictionary, ref: FIRDatabaseReference) -> [Expense] {
        var expenses = [Expense]()
        expenses.removeAll()
        
//        for result in results {
//            var expense = Expense()
//            switch result.key as! String {
//            case "billAmount":
//                expense.billAmount = result.value as! Float
//            case "category":
//                expense.category = result.value as! String
//            case "dateAdded":
//                expense.dateAdded = result.value as! String
//            case "dateAdded":
//                expense.dateAdded = result.value as! String
//            default:
//                break
//            }
//            expenses.append(expense)
//        }
        
        if results.count > 0 {
            for result in results {
                
                if let valueDictionary = result.value as? NSDictionary {
                    var expense = Expense()
                    for value in valueDictionary {
                        
                        
                        expense.expenseId = result.key as! String
                        expense.firebaseDBRef = ref
                        
                        switch value.key as! String {
                        case "billAmount":
                            expense.billAmount = value.value as! Float
                        case "category":
                            expense.category = value.value as! String
                        case "dateAdded":
                            expense.dateAdded = value.value as! String
                        case "dateAdded":
                            expense.dateAdded = value.value as! String
                        default:
                            break
                        }
                        
                    }
                    expenses.append(expense)
                    
                }
            }
            
        }
        
        print(expenses)
        return expenses
    }
}