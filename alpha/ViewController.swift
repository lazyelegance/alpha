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
    
    var expenses = [Expense]()

    @IBOutlet weak var youOweLabel: UILabel!
    
    @IBOutlet weak var groupButton: RaisedButton!
    
    @IBOutlet weak var userButton: RaisedButton!
    
    
    @IBOutlet weak var mainBalance: UILabel!
    
    @IBOutlet weak var userImageView: AsyncImageView!
    
    @IBOutlet weak var helloLabel: UILabel!
    
    var user = User()
    var group = Group()
    var groupMembers = [User]()
    
    var alphaExpensesRef = FIRDatabaseReference.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

      
        
        self.navigationController?.navigationBar.hidden = true
        
        view.backgroundColor = MaterialColor.indigo.accent3
        groupButton.backgroundColor = MaterialColor.indigo.accent4
        groupButton.layer.shadowOpacity = 0.1
        
        userButton.backgroundColor = MaterialColor.indigo.accent4
        userButton.layer.shadowOpacity = 0.1
        
        
        
        mainBalance.font = RobotoFont.lightWithSize(50)
                
        alphaExpensesRef = FIRDatabase.database().reference()
        
    
        
        btn1.addTarget(self, action: #selector(ViewController.handleFlatMenu), forControlEvents: .TouchUpInside)
        btn1.setTitleColor(MaterialColor.blue.accent1, forState: .Normal)
        btn1.titleLabel?.font = RobotoFont.regularWithSize(12)
        btn1.backgroundColor = MaterialColor.white
        btn1.pulseColor = MaterialColor.white
        btn1.setTitle("Menu".uppercaseString, forState: .Normal)
        
        
        //btn1.setImage(MaterialIcon.menu, forState: .Normal)
        
        view.addSubview(btn1)
        
        
        btn2.setTitleColor(MaterialColor.white, forState: .Normal)
        btn2.titleLabel?.font = RobotoFont.boldWithSize(12)
        //btn2.borderColor = MaterialColor.white
        btn2.pulseColor = MaterialColor.blue.accent3
        //btn2.borderWidth = 1
        btn2.setTitle("Add Expense".uppercaseString, forState: .Normal)
        btn2.addTarget(self, action: #selector(ViewController.toAddExpenseCycle), forControlEvents: .TouchUpInside)
        view.addSubview(btn2)
        
        
        btn3.setTitleColor(MaterialColor.white, forState: .Normal)
        btn3.titleLabel?.font = RobotoFont.boldWithSize(12)
//        btn3.borderColor = MaterialColor.blueGrey.lighten1
        btn3.pulseColor = MaterialColor.blue.accent3
//        btn3.borderWidth = 1
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
        
        
        mainBalance.text = "0.0 $"
        

        

        
    }

    
    override func viewWillAppear(animated: Bool) {
        
        flatMenu.close()
        
        if let currentUser = FIRAuth.auth()?.currentUser {
            
            
            
            
            if let name = currentUser.displayName as String!, email = currentUser.email as String! {
                helloLabel.text = "Welcome"
                helloLabel.alpha = 1
                
                print(currentUser.photoURL)
                
                alphaExpensesRef.child("users").queryOrderedByChild("email").queryEqualToValue(email).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    
                    self.user = User.userFromFirebase(snapshot.value! as! NSDictionary)
                    
                    self.mainBalance.text = "\(self.user.amountOwing) $"
                    self.helloLabel.text = "Hello, "
                    self.userButton.setTitle(self.user.name, forState: .Normal)
                    self.groupButton.setTitle(self.user.defaultGroupName, forState: .Normal)
                    self.userButton.alpha = 1
                    self.groupButton.alpha = 1
                    self.mainBalance.alpha = 1
                    self.youOweLabel.alpha = 1
                    
                    self.alphaExpensesRef.child("expenses/\(self.user.defaultGroupId)").observeEventType(.Value, withBlock: { (snapshot) in
                        
                        self.expenses = Expense.expensesFromFirebase(snapshot.value! as! NSDictionary, firebasereference: snapshot.ref)
                    })
                    
                    self.alphaExpensesRef.child("groups/\(self.user.defaultGroupId)").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
//                        self.group = Group.groupFromFirebase(self.user.defaultGroupId, results: snapshot.value! as! NSDictionary)
                        self.group = Group.groupFromFirebase(self.user.defaultGroupId, results: snapshot.value! as! NSDictionary)
                    })
                    
                    self.alphaExpensesRef.child("users").queryOrderedByChild("defaultGroupId").queryEqualToValue(self.user.defaultGroupId).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                        self.groupMembers = User.usersFromResults(snapshot.value! as! NSDictionary)
                    })
                    
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
        
        let ezrakey = alphaExpensesRef.child("groups").childByAutoId().key
        let ramkey = alphaExpensesRef.child("groups").childByAutoId().key
        let alphakey = "-KN2R518jhzzednYYZ73"
        
        alphaExpensesRef.child("users").updateChildValues([ezrakey : ["name": "ezra", "title" : "Director of Awesomeness",
            "amountOwing": 1600, "defaultGroup": "alpha708" ,"groups": [alphakey: true], "email": "ezrabathini@gmail.com"]])
        
        alphaExpensesRef.child("users").updateChildValues([ramkey : ["name": "ram", "title" : "Director of BS",
            "amountOwing": -1600, "defaultGroup": "alpha708", "groups": [alphakey : true], "email": "ev.ramkumar@gmail.com"]])
        
//        alphaExpensesRef.child("users").updateChildValues([key1 : ["name": "ezra", "title" : "Director of Awesomeness",
//            "amountOwing": 1600.09, "defaultGroup": "alpha708" ,"groups": ["alpha708": true], "email": "ezrabathini@gmail.com"], key2 : ["name": "ram", "title" : "Director of BS",
//                "amountOwing": -1600.09, "defaultGroup": "alpha708", "groups": ["alpha708": true], "email": "ev.ramkumar@gmail.com"]])
//
        alphaExpensesRef.child("groups").updateChildValues([alphakey : ["name": "alpha708", "members" : [ezrakey: true, ramkey: true]]])
//
//        
        
        
//        let key = alphaExpensesRef.child("expenses").childByAutoId().key
//        
//        alphaExpensesRef.child("expenses").updateChildValues([key : ["Total": 120.00, "addedBy": "ezra", "description": "some desription", "spent": ["ezra": 1, "ram": 0 ], "parity" : ["ezra" : 1, "ram": 1], "share": ["ezra": 60.00, "ram": 60.00 ], "settlemet": ["ezra": 60.00, "ram": -60.00 ]  ]])
        
//        if let currentUser = FIRAuth.auth()?.currentUser?.displayName {
//            let post = ["Total": 909.99, "addedBy": currentUser, "Description": "some desription"]
//            
//            let childUpdates = ["/expenses/\(key)": post]
//            alphaExpensesRef.updateChildValues(childUpdates)
//        }
//        
        
        
    }

    func toListExpenses() {
        if let expensesListController = self.storyboard?.instantiateViewControllerWithIdentifier("expensesListController") as? ExpensesListController {
            expensesListController.expenses = self.expenses
            expensesListController.groupName = self.group.name
            self.navigationController?.pushViewController(expensesListController, animated: true)
        }
    }
    
    func toAddExpenseCycle() {
        print(self.user)
        print(self.group)
        if let addExpenseVC = self.storyboard?.instantiateViewControllerWithIdentifier("addExpenseController") as? AddExpenseController {
            addExpenseVC.currentStep = AddExpenseStep.description
            
            var owing = [String : Float]()
            owing.removeAll()
            
            for member in groupMembers {
                owing[member.name] = member.amountOwing
            }
            
            print(owing)
            
            var newExpense = Expense()
            newExpense.addedBy = user.name 
            newExpense.group = user.defaultGroupName
            newExpense.groupId = user.defaultGroupId
            newExpense.groupMembers = groupMembers
            newExpense.owing = owing
            newExpense.firebaseDBRef = self.alphaExpensesRef
            
            addExpenseVC.newExpense = newExpense
            self.navigationController?.pushViewController(addExpenseVC, animated: true)
        }
    }
    

}

