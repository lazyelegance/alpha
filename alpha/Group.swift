//
//  Group.swift
//  alpha
//
//  Created by Ezra Bathini on 20/07/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import Foundation


struct Group {
    var groupId: String
    var name = String()
    var members = [String]()
    var lastExpense = String()
    
    init() {
        self.groupId = "0"
    }
    
    static func groupFromFirebase(groupId: String, results: NSDictionary) -> Group {
        var group = Group()
        
        print(results.allKeys)
        group.groupId = groupId
        group.members.removeAll()
    
        
        if results.count > 0 {
            for result in results {
                switch result.key as! String {
                case "name":
                    group.name = result.value as! String
                case "members":
                    let memberDict = result.value as! [String : Bool]
                    print(memberDict)
                    for member in memberDict {
                        group.members.append(member.0)
                    }
                case "lastExpense":
                    group.lastExpense = result.value as! String
                default:
                    break
                }
            }
        }
        
        print(group)
        
        
        return group
    }
    
}