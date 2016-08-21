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
    @IBOutlet weak var userName: UILabel!

    @IBOutlet weak var profileImage: AsyncImageView!
    
    
    @IBAction func logOutAction(sender: AnyObject) {
        try! FIRAuth.auth()!.signOut()
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
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
