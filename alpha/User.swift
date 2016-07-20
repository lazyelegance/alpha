//
//  User.swift
//  alpha
//
//  Created by Ezra Bathini on 19/07/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct User {
    //
    var userUID: String
    var name: String
    var email = String()
    var amountOwing = Float()
    var defaultGroupId = String()
    var defaultGroupName = String()
    var title = String()
    var groups = [String : Bool]()
    var current = false
    
    init() {
        self.userUID = "1"
        self.name = "New User"
    }
    
    static func usersFromResults(results: NSDictionary) -> [User] {
        var users = [User]()
        
        users.removeAll()
        
        var user = User()
        
        if results.count > 0 {
            for result in results {
                
                if let valueDictionary = result.value as? NSDictionary {
                    user.userUID = result.key as! String
                    
                    for value in valueDictionary {
                        switch value.key as! String {
                        case "amountOwing":
                            user.amountOwing = value.value as! Float
                        case "name":
                            user.name = value.value as! String
                        case "defaultGroup":
                            user.defaultGroupName = value.value as! String
                        case "defaultGroupId":
                            user.defaultGroupId = value.value as! String
                        case "email":
                            user.email = value.value as! String
                        case "title":
                            user.title = value.value as! String
                        case "groups":
                            user.groups = value.value as! [String:Bool]
                        default:
                            break
                        }
                    }
                    
                }
                users.append(user)
                
            }
        }
        
        print(users)
        return users
    }
    
    static func userFromFirebase(results: NSDictionary) -> User {
        var user = User()
        
        
        if results.count > 0 {
            for result in results {
                
                if let valueDictionary = result.value as? NSDictionary {
                    user.userUID = result.key as! String
                    for value in valueDictionary {
                        switch value.key as! String {
                        case "amountOwing":
                            user.amountOwing = value.value as! Float
                        case "name":
                            user.name = value.value as! String
                        case "defaultGroup":
                            user.defaultGroupName = value.value as! String
                        case "defaultGroupId":
                            user.defaultGroupId = value.value as! String
                        case "email":
                            user.email = value.value as! String
                        case "title":
                            user.title = value.value as! String
                        case "groups":
                            user.groups = value.value as! [String:Bool]
                        default:
                            break
                        }
                    }
                    
                }
            }
        }
        
        
        return user
    }
    
    
}
