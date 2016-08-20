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
        
        FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                self.updateUserDBRecord(user!)
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
        
        alphaRef.child("users").updateChildValues([user.uid : ["userId": user.uid ,"name": user.displayName!, "email": user.email!, "photoURL" : user.photoURL!.absoluteString]])
        
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
