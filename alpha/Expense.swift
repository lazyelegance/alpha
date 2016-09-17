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
    var month = String()
    var week = String()
    var day = String()
    var year = String()
    
    var firebaseDBRef = FIRDatabaseReference()
    
    init() {
        self.description = "New User Expense --"
        self.billAmount = 0.00
    }
    
    
    static func totalsFromResults(_ results: NSDictionary) -> [String : Float] {
        
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
    
    static func categoryFromResults(_ results: NSDictionary) -> [String : Float] {
        
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
    
    static func categoriesFromResults(_ results: NSDictionary) -> [String : [String: Float]] {
        
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
    
    static func categoryNamesFromResults(_ results: NSDictionary) -> [String: Int] {
        
        var categoryNames = [String: Int]()
        categoryNames.removeAll()
        
        if results.count > 0 {
            for result in results {
                if let resultKey = result.key as? String {
                    if resultKey == "categories" {
                        if let valueDictionary = result.value as? NSDictionary {
                            for value in valueDictionary {
                                if let categoryDictionary = value.value as? NSDictionary {
                                    for catValue in categoryDictionary {
                                        if catValue.key as! String == "counter" {
                                            categoryNames[value.key as! String] = (catValue.value as! Int)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            
            return categoryNames
        }
        
        
        return ["noCategory": 0]
    }
    
    static func monthsFromResults(_ results: NSDictionary) -> [String] {
        
        var months = [String]()
        months.removeAll()
        
        if results.count > 0 {
            for result in results {
                if let resultKey = result.key as? String {
                    if resultKey == "totals" {
                        if let valueDictionary = result.value as? NSDictionary {
                            for value in valueDictionary {
                                if let valueKey = value.key as? String {
                                    if valueKey.hasPrefix("m_") {
                                        let month = valueKey.replacingOccurrences(of: "m_", with: "").replacingOccurrences(of: "_", with: " ")
                                        months.append(month)
                                    }
                                    
                                }
                                
                            }
                            
                        }
                    }
                }
            }
            
            
            return months
        }
        
        
        return ["noCategory"]
    }

    
    static func expensesFromResults(_ results: NSDictionary, ref: FIRDatabaseReference) -> [Expense] {
        var expenses = [Expense]()
        expenses.removeAll()
        

        
        if results.count > 0 {
            for result in results {
                if let resultKey = result.key as? String {
                    if resultKey != "totals" && resultKey != "categories" && resultKey != "monthlyLimit" {
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
                                case "description":
                                    expense.description = value.value as! String
                                case "dateAdded":
                                    expense.dateAdded = value.value as! String
                                case "month":
                                    expense.month = value.value as! String
                                case "week":
                                    expense.week = value.value as! String
                                case "day":
                                    expense.day = value.value as! String
                                case "year":
                                    expense.year = value.value as! String
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
