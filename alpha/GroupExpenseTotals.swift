//
//  GroupExpenseTotals.swift
//  alpha
//
//  Created by Ezra Bathini on 30/07/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase


struct GroupExpenseTotals {
    var owing = [String: Float]()
    var spent = [String: Float]()
    var totalSpent = Float()
    var groupId = String()
    
    static func totalsFromResults(groupId: String, results: NSDictionary) -> GroupExpenseTotals {
        
        var totals = GroupExpenseTotals()
        
        
        if results.count > 0 {
            totals.groupId = groupId
            for result in results {
                switch result.key as! String {
                case "totalSpent":
                    totals.totalSpent = result.value as! Float
                case "owing":
                    totals.owing = result.value as! [String: Float]
                case "spent":
                    totals.spent = result.value as! [String: Float]
                default:
                    break
                }
                
            }
            
            return totals
        }
        
        
        return totals
    }
    
    
}
