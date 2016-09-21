//
//  LoginViewController.swift
//  alpha
//
//  Created by Ezra Bathini on 16/07/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase



class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        // ...
        
        let authentication = user.authentication
        let credential = FIRGoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!,
                                                          accessToken: (authentication?.accessToken)!)
        // ...
        
        print("signing in")
        print(user.profile.email)
        print(user.profile.imageURL(withDimension: 400))
        
        FIRAuth.auth()?.signIn(with: credential) { (firUser, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                //firUser?.photoURL = user.profile.imageURLWithDimension(400)
                self.updateUserDBRecord(firUser!)
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }

    
    var alphaRef = FIRDatabaseReference()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = MaterialColor.indigo.accent2
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        let signInButton = GIDSignInButton(frame: CGRect(x: 30, y: 50, width: 100, height: 50))
        
        signInButton.style = .wide
        
        let signInButtonWidth = signInButton.frame.size.width
        print(signInButtonWidth)
        
        signInButton.frame.origin = CGPoint(x: view.bounds.width/2 - signInButtonWidth/2, y: view.bounds.height - 100)
        
        view.addSubview(signInButton)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
                withError error: NSError!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        // ...
        
        let authentication = user.authentication
        let credential = FIRGoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!,
                                                                     accessToken: (authentication?.accessToken)!)
        // ...
        
        print("signing in")
        print(user.profile.email)
        print(user.profile.imageURL(withDimension: 400))
        
        FIRAuth.auth()?.signIn(with: credential) { (firUser, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                //firUser?.photoURL = user.profile.imageURLWithDimension(400)
                self.updateUserDBRecord(firUser!)
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!,
                withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    
    func updateUserDBRecord(_ user: FIRUser) {
        print(user.photoURL)
        print("\(user.photoURL)")
        
        alphaRef.child("users/\(user.uid)").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                print(snapshot)
            } else {
                self.alphaRef.child("users").updateChildValues([user.uid : ["userId": user.uid ,"name": user.displayName!, "email": user.email!]])
                if user.photoURL != nil {
                    self.alphaRef.child("users/\(user.uid)/photoURL").setValue("\(user.photoURL!)")
                }
            }
        })
        
        
        alphaRef.child("groups").queryOrdered(byChild: "members").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                
                var groups = [String : Bool]()
                groups.removeAll()
                if let groupMembers = Group.membersFromResults(snapshot.value! as! NSDictionary) as [String: String]?  {
                    for groupMember in groupMembers {
                        if user.uid == groupMember.0 {
                            groups[groupMember.1    ] = true
                        }
                    }
                }
                self.alphaRef.child("users/\(user.uid)").updateChildValues(["groups" : groups])
            } else {
                print("... no snap")
            }
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
