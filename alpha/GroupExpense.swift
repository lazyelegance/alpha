//
//  Expense.swift
//  alpha
//
//  Created by Ezra Bathini on 17/07/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct GroupExpense {
    //
    var expenseId = String()
    var description: String
    var billAmount: Float
    var dateAdded = String()
    var spent = [String: Int]()
    var settlement = [String: Float]()
    var share = [String: Float]()
    var parity = [String: Int]()
    var addedBy = String()
    var group = String()
    var groupId = String()
    var groupMembers = [User]()
    var owing = [String: Float]()
    var firebaseDBRef = FIRDatabaseReference()
    
    
    init() {
        self.description = "New Group Expense"
        self.billAmount = 0.00
    }
    
    
    static func expensesFromFirebase(results: NSDictionary, firebasereference: FIRDatabaseReference) -> [GroupExpense] {
        var expenses = [GroupExpense]()
        
        expenses.removeAll()
        
        
        
        
        if results.count > 0 {
            for result in results {
                
                if let valueDictionary = result.value as? NSDictionary {
                    var expense = GroupExpense()
                    for value in valueDictionary {
                        
                        
                        expense.expenseId = result.key as! String
                        expense.firebaseDBRef = firebasereference
                        
                        switch value.key as! String {
                        case "description":
                            expense.description = value.value as! String
                        case "addedBy":
                            expense.addedBy = value.value as! String
                        case "dateAdded":
                            expense.dateAdded = value.value as! String
                        case "group":
                            expense.group = value.value as! String
                        case "billAmount":
                            expense.billAmount = value.value as! Float
                        case "parity":
                            expense.parity = value.value as! [String: Int]
                        case "share":
                            expense.share = value.value as! [String: Float]
                        case "settlement":
                            expense.settlement = value.value as! [String: Float]
                        case "spent":
                            expense.spent = value.value as! [String: Int]
                        case "owing":
                            expense.owing = value.value as! [String: Float]
                        default:
                            break
                        }
                        
                    }
                    expenses.append(expense)
                    
                }
            }
            
        }
        
        return expenses
    }
    
}