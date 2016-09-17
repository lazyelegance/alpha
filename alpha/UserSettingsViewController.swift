//
//  UserSettingsViewController.swift
//  alpha
//
//  Created by Ezra Bathini on 20/08/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class UserSettingsViewController: UIViewController {
    
    
    var user = User()
    var expensesRef = FIRDatabaseReference()
    
    @IBOutlet weak var groupOptionsView: MaterialView!
    
    
    @IBOutlet weak var userName: UILabel!

    @IBOutlet weak var profileImage: AsyncImageView!
    
    @IBAction func backToHome(_ sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logOutAction(_ sender: AnyObject) {
        try! FIRAuth.auth()!.signOut()
        GIDSignIn.sharedInstance().signOut()
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBOutlet weak var monthlyLimitLabel: UILabel!
    
    @IBAction func increamentMontlyLimit(_ sender: AnyObject) {
        self.expensesRef.child("monthlyLimit").setValue(self.monthlyLimit + 50)
    }
    
    @IBAction func decrementMonthlyLimit(_ sender: AnyObject) {
        self.expensesRef.child("monthlyLimit").setValue(self.monthlyLimit - 50)
    }
    
    var monthlyLimit = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareView()
        prepareMonthlyLimit()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    fileprivate func prepareView() {
        view.backgroundColor = MaterialColor.lightBlue.base
        monthlyLimitLabel.text = String(monthlyLimit)
        userName.text = user.name
        if user.photoURL != "" {
            profileImage.imageURL = URL(string: user.photoURL)
        }
        
    }
    
    func prepareMonthlyLimit() {
        self.expensesRef.child("monthlyLimit").observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                self.monthlyLimit = snapshot.value! as! Int
                self.monthlyLimitLabel.text = String(self.monthlyLimit)
            } else {

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
