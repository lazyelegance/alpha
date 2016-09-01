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
    var category = String()
    var owing = [String: Float]()
    var month = String()
    var week = String()
    var firebaseDBRef = FIRDatabaseReference()
    
    
    init() {
        self.expenseId = "0"
        self.description = "New Group Expense"
        self.billAmount = 0.00
    }
    
    static func totalsFromResults(results: NSDictionary) -> [String : AnyObject] {
        
        var totals = [String: AnyObject]()
        totals.removeAll()
        
        if results.count > 0 {
            print(results)
            for result in results {
                totals[result.key as! String] = (result.value)
                
            }
            
            return totals
        }
        
        
        return ["total": 0.0]
    }
    
    static func categoryFromResults(results: NSDictionary) -> [String : Float] {
        
        var totals = [String: Float]()
        totals.removeAll()
        
        if results.count > 0 {
            
            for result in results {
                totals[result.key as! String] = (result.value as! Float)
                
            }
            
            return totals
        }
        
        
        return ["total": 0.0]
    }
    
    static func categoriesFromResults(results: NSDictionary) -> [String : [String: Float]] {
        
        var categories = [String: [String: Float]]()
        categories.removeAll()
        
        if results.count > 0 {
            
            for result in results {
                categories[result.key as! String] = (result.value as! [String: Float])
                
            }
            
            return categories
        }
        
        
        return ["noCategory": ["none":0.0]]
    }
    
    static func expenseFromResults(expenseId: String, results: NSDictionary) -> GroupExpense {
        var expense = GroupExpense()
        
        if results.count > 0 {
            expense.expenseId = expenseId
            for value in results {
                switch value.key as! String {
                case "addedBy":
                    expense.addedBy = value.value as! String
                case "billAmount":
                    expense.billAmount = value.value as! Float
                case "dateAdded":
                    expense.dateAdded = value.value as! String
                case "description":
                    expense.description = value.value as! String
                case "defaultGroupId":
                    expense.owing = value.value as! [String: Float]
                case "spent":
                    expense.spent = value.value as! [String: Int]
                case "share":
                    expense.share = value.value as! [String: Float]
                case "parity":
                    expense.parity = value.value as! [String: Int]
                case "settlement":
                    expense.settlement = value.value as! [String: Float]
                default:
                    break
                }
            }
        }
        
        return expense
    }
    
    
    static func expensesFromFirebase(results: NSDictionary, firebasereference: FIRDatabaseReference) -> [GroupExpense] {
        var expenses = [GroupExpense]()
        
        expenses.removeAll()
        if results.count > 0 {
            for result in results {
                if let resultKey = result.key as? String {
                    if resultKey != "totals" && resultKey != "categories" {
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
                                case "month":
                                    expense.month = value.value as! String
                                case "week":
                                    expense.week = value.value as! String
                                default:
                                    break
                                }
                                
                            }
                            expenses.append(expense)
                            
                        }
                    }
                }
            }   
        }
        
        return expenses
    }
    
}