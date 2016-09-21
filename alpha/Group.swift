//
//  Group.swift
//  alpha
//
//  Created by Ezra Bathini on 20/07/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ success:Bool) -> Void

struct Group {
    var groupId: String
    var name = String()
    var members = [String]()
    var lastExpense = String()
    var imageString = String()
    var imageURLString = String()
    
    init() {
        self.groupId = "0"
        self.imageString = "default_group"
    }
    
    //temp
    
    init(name: String, lastExpense: String) {
        self.init()
        self.name = name
        self.lastExpense = lastExpense
        
    }
    
    
    static func membersFromResults(_ results: NSDictionary)  -> [String : String]
    {
        var member = [String: String]()
        if results.count > 0 {
            for result in results {
                if let valueDict = result.value as? NSDictionary {
                    if let memberDict = valueDict["members"] as? NSDictionary {
                        for element in memberDict {
                            member[element.key as! String] = result.key as? String
                        }
                    }
                }
            }
        }
        return member
    }
    
    
    static func groupFromFirebase(_ groupId: String, results: NSDictionary) -> Group {
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
                    group.lastExpense = result.value as! String
                case "imageString":
                    group.imageString = result.value as! String
                default:
                    break
                }
            }
        }
        
        
        
        
        return group
    }
    
}
