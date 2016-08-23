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
import Material



class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    var alphaRef = FIRDatabaseReference()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = MaterialColor.indigo.accent2
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        let signInButton = GIDSignInButton(frame: CGRectMake(30, 50, 100, 50))
        
        signInButton.style = .Wide
        
        let signInButtonWidth = signInButton.frame.size.width
        print(signInButtonWidth)
        
        signInButton.frame.origin = CGPointMake(view.bounds.width/2 - signInButtonWidth/2, view.bounds.height - 100)
        
        view.addSubview(signInButton)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        // ...
        
        let authentication = user.authentication
        let credential = FIRGoogleAuthProvider.credentialWithIDToken(authentication.idToken,
                                                                     accessToken: authentication.accessToken)
        // ...
        
        print("signing in")
        print(user.profile.email)
        print(user.profile.imageURLWithDimension(400))
        
        FIRAuth.auth()?.signInWithCredential(credential) { (firUser, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                //firUser?.photoURL = user.profile.imageURLWithDimension(400)
                self.updateUserDBRecord(firUser!)
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    
    func updateUserDBRecord(user: FIRUser) {
        print(user.photoURL)
        print("\(user.photoURL)")
        
        alphaRef.child("users/\(user.uid)").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if snapshot.exists() {
                print(snapshot)
            } else {
                self.alphaRef.child("users").updateChildValues([user.uid : ["userId": user.uid ,"name": user.displayName!, "email": user.email!]])
                if user.photoURL != nil {
                    self.alphaRef.child("users/\(user.uid)/photoURL").setValue("\(user.photoURL!)")
                }
            }
        })
        
        
        alphaRef.child("groups").queryOrderedByChild("members").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
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
