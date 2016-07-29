//
//  Group.swift
//  alpha
//
//  Created by Ezra Bathini on 20/07/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import Foundation

typealias CompletionHandler = (success:Bool) -> Void

struct Group {
    var groupId: String
    var name = String()
    var members = [String]()
    var lastExpense = Float()
    
    init() {
        self.groupId = "0"
    }
    
    //temp
    
    init(name: String, lastExpense: Float) {
        self.init()
        self.name = name
        self.lastExpense = lastExpense
        
    }
    
    static func groupFromFirebase(groupId: String, results: NSDictionary) -> Group {
        var group = Group()
        
        group.groupId = groupId
        group.members.removeAll()
    
        
        if results.count > 0 {
            
            
            for result in results {
                switch result.key as! String {
                case "name":
                    group.name = result.value as! String
                case "members":
                    let memberDict = result.value as! [String : Bool]
                    for member in memberDict {
                        group.members.append(member.0)
                    }
                    
                case "lastExpense":
                    group.lastExpense = result.value as! Float
                default:
                    break
                }
            }
        }
        
        
        
        
        return group
    }
    
}