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
    var name: String
    var email = String()
    var amountOwing = Float()
    var defaultGroup = String()
    var title = String()
    var groups = [String : Bool]()
    
    init() {
        self.name = "New User"
    }
    
    static func userFromFirebase(results: NSDictionary) -> User {
        var user = User()
        
        if results.count > 0 {
            for result in results {
                
            }
        }
        
        
        
        return user
    }
    
    
}
