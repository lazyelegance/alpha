//
//  UserSettingsViewController.swift
//  alpha
//
//  Created by Ezra Bathini on 20/08/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import Material
import FirebaseAuth


class UserSettingsViewController: UIViewController {
    
    
    
    @IBOutlet weak var groupOptionsView: MaterialView!
    
    
    @IBOutlet weak var userName: UILabel!

    @IBOutlet weak var profileImage: AsyncImageView!
    
    @IBAction func backToHome(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func logOutAction(sender: AnyObject) {
        try! FIRAuth.auth()!.signOut()
        GIDSignIn.sharedInstance().signOut()
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBOutlet weak var monthlyLimitLabel: UILabel!
    
    @IBAction func increamentMontlyLimit(sender: AnyObject) {
        monthlyLimit = monthlyLimit + 50
        monthlyLimitLabel.text = String(monthlyLimit)
    }
    
    @IBAction func decrementMonthlyLimit(sender: AnyObject) {
        monthlyLimit = monthlyLimit - 50
        monthlyLimitLabel.text = String(monthlyLimit)
    }
    
    var monthlyLimit = 2000
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareView()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func prepareView() {
        view.backgroundColor = MaterialColor.lightBlue.base
        monthlyLimitLabel.text = String(monthlyLimit)
        
        
        
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
