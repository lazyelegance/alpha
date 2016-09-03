//
//  Category.swift
//  alpha
//
//  Created by Ezra Bathini on 3/09/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import Foundation

struct Category {
    var name: String
    var imageName = String()
    var counter = Int()
    var total = Float()
    var thisMonth = Float()
    var thisWeek = Float()
    
    var months = [String: Float]()
    var weeks = [String: Float]()
    
    init() {
        self.name = "New Category"
        self.counter = 0
        self.total = 0
        self.imageName = "cone"
    }
    

    
    static func categoriesFromResults(results: NSDictionary) -> [Category] {
        var categories = [Category]()
        if results.count > 0 {
            categories.removeAll()
            for result in results {
                var category = Category()
                category.name = result.key as! String
                
                if let valueDictionary = result.value as? [String : AnyObject] {
                    
                    let (_, currMonth, currWeek) = calculateDateValues()
                    
                    for value in valueDictionary {
                        
                        if value.0 == "total" {
                            category.total = (value.1 as! Float)
                        } else if value.0 == "counter" {
                            category.counter = (value.1 as! Int)
                        } else if value.0 == "imageName" {
                            category.imageName = value.1 as! String
                        } else if value.0.hasPrefix("m_") {
                            let month = value.0.stringByReplacingOccurrencesOfString("m_", withString: "").stringByReplacingOccurrencesOfString("_", withString: " ")
                            category.months[month] = (value.1 as! Float)
                            
                            if value.0 == currMonth {
                                category.thisMonth = (value.1 as! Float)
                            } else {
                                category.thisMonth = 0.0
                            }
                            
                            
                        } else if value.0.hasPrefix("w_") {
                            let week = value.0.stringByReplacingOccurrencesOfString("w_", withString: "").stringByReplacingOccurrencesOfString("_", withString: " ")
                            category.weeks[week] = (value.1 as! Float)
                            if value.0 == currWeek {
                                category.thisWeek = (value.1 as! Float)
                            } else {
                                category.thisWeek = 0.0
                            }
                        }
                    }
                }
                categories.append(category)
            }
            
            return categories
        }

        return categories
    }
}
