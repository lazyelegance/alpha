//
//  ViewController.swift
//  alpha
//
//  Created by Ezra Bathini on 15/07/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import Material

class ViewController: UIViewController {
    
    private var fabMenu: Menu!
    private var flatMenu: Menu!
    private var flashMenu: Menu!
    
    let spacing: CGFloat = 16
    let diameter: CGFloat = 56
    let height: CGFloat = 36
    
    let btn1: FlatButton = FlatButton()
    let btn2: FlatButton = FlatButton()
    let btn3: FlatButton = FlatButton()

    
    @IBOutlet weak var mainBalance: UILabel!
    
    @IBOutlet weak var userImageView: AsyncImageView!
    
    @IBOutlet weak var userDisplayName: UILabel!
    
    
    
    var alphaExpensesRef = FIRDatabaseReference.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.navigationBar.hidden = true
        
        alphaExpensesRef = FIRDatabase.database().reference()
        
        btn1.addTarget(self, action: #selector(ViewController.handleFlatMenu), forControlEvents: .TouchUpInside)
        btn1.setTitleColor(MaterialColor.blue.accent3, forState: .Normal)
        btn1.titleLabel?.font = RobotoFont.regularWithSize(12)
        btn1.backgroundColor = MaterialColor.white
        btn1.pulseColor = MaterialColor.white
        btn1.setTitle("Menu".uppercaseString, forState: .Normal)
        view.addSubview(btn1)
        
        
        btn2.setTitleColor(MaterialColor.white, forState: .Normal)
        btn2.titleLabel?.font = RobotoFont.regularWithSize(12)
        btn2.borderColor = MaterialColor.white
        btn2.pulseColor = MaterialColor.blue.accent3
        btn2.borderWidth = 1
        btn2.setTitle("Add Expense".uppercaseString, forState: .Normal)
        btn2.addTarget(self, action: #selector(ViewController.toAddExpenseCycle), forControlEvents: .TouchUpInside)
        view.addSubview(btn2)
        
        
        btn3.setTitleColor(MaterialColor.blueGrey.lighten1, forState: .Normal)
        btn3.titleLabel?.font = RobotoFont.regularWithSize(12)
        btn3.borderColor = MaterialColor.blueGrey.lighten1
        btn3.pulseColor = MaterialColor.blue.accent3
        btn3.borderWidth = 1
        btn3.setTitle("See Expenses".uppercaseString, forState: .Normal)
        btn3.addTarget(self, action: #selector(ViewController.toListExpenses), forControlEvents: .TouchUpInside)
        view.addSubview(btn3)
        
        let btn4: FlatButton = FlatButton()
        btn4.setTitleColor(MaterialColor.blue.accent3, forState: .Normal)
        btn4.borderColor = MaterialColor.blue.accent3
        btn4.pulseColor = MaterialColor.blue.accent3
        btn4.borderWidth = 1
        btn4.setTitle("Item", forState: .Normal)
        view.addSubview(btn4)
        
        // Initialize the menu and setup the configuration options.
        
        flatMenu = Menu(origin: CGPointMake(view.bounds.width/2 - 60, view.bounds.height - height - spacing))
        flatMenu.direction = .Up
        flatMenu.spacing = 8
        flatMenu.itemSize = CGSizeMake(120, height)
        flatMenu.views = [btn1, btn2, btn3]

        
    }

    override func viewWillAppear(animated: Bool) {
        print(FIRAuth.auth()?.currentUser)
        view.backgroundColor = MaterialColor.blueGrey.lighten3
        
        userImageView.layer.masksToBounds = true
        userImageView.layer.cornerRadius = 40
        userImageView.layer.borderColor = MaterialColor.white.CGColor
        userImageView.layer.borderWidth = 4
        
        if let currentUser = FIRAuth.auth()?.currentUser {
            print(currentUser.displayName)
            print(currentUser.photoURL)
            print(currentUser.uid)
            userImageView.imageURL = currentUser.photoURL
            
            if let name = currentUser.displayName as String!, email = currentUser.email as String! {
                userDisplayName.text = "hi, \(name)"
                
                alphaExpensesRef.child("users").queryOrderedByChild("email").queryEqualToValue(email).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    print("=========================")
                    
                    print(snapshot.value)
                    if let spdict = snapshot.value as? NSDictionary {
                        if let name = spdict.allKeys[0] as? String {
                            self.alphaExpensesRef.child("users/\(name)/amountOwed").observeEventType(.Value, withBlock: { (snapshot) in
                                self.userDisplayName.text = "hi, \(name)"
                                self.mainBalance.text = "$\(snapshot.value!)"
                            })
                            
                        }
                        
                    }
                    
                    
                    print("=========================")
                })
                
            }
            
            
            
        } else {
            if let loginViewController = self.storyboard!.instantiateViewControllerWithIdentifier("loginViewController") as? LoginViewController {
                self.navigationController?.pushViewController(loginViewController, animated: true)
            } else {
                print("cannot instantiate login")
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Button Menus
    
    func handleFlatMenu() {
        // Only trigger open and close animations when enabled.
        if flatMenu.enabled {
            if flatMenu.opened {
                flatMenu.close()
            } else {
                flatMenu.open()
            }
        }
    }
    
    
    func addExpenseTemp() {
        print("boom")
        
        
        
//        alphaExpensesRef.updateChildValues(["users" : ["ezra" : ["name": "ezra", "title" : "Director of Awesomeness",
//            "amountOwed": 1600.09, "groups": ["alpha708": true]], "ram" : ["name": "ram", "title" : "Director of BS",
//                "amountOwed": -1600.09, "groups": ["alpha708": true]]]])
//        
//        alphaExpensesRef.updateChildValues(["groups": ["alpha708": ["name": "Alpha 708", "members" : ["ezra": true, "ram": true]]]])
//    
//        
//        
//        alphaExpensesRef.updateChildValues(["expenses" : ["alpla708" : ["Total": 909.99, "addedBy": "ezra", "Description": "some desription"]]])
        
//        if let currentUser = FIRAuth.auth()?.currentUser?.displayName {
//            let post = ["Total": 909.99, "addedBy": currentUser, "Description": "some desription"]
//            
//            let childUpdates = ["/expenses/\(key)": post]
//            alphaExpensesRef.updateChildValues(childUpdates)
//        }
//        
        
        
    }

    func toListExpenses() {
//        if let listExpensesVC = self.storyboard?.instantiateViewControllerWithIdentifier("ListExpensesController") as? ListExpensesController {
//            listExpensesVC.expenses = self.expenses
//            self.navigationController?.pushViewController(listExpensesVC, animated: true)
//        }
    }
    
    func toAddExpenseCycle() {
        if let addExpenseVC = self.storyboard?.instantiateViewControllerWithIdentifier("addExpenseController") as? AddExpenseController {
            addExpenseVC.currentStep = AddExpenseStep.description
            
            self.navigationController?.pushViewController(addExpenseVC, animated: true)
        }
    }
    

}

