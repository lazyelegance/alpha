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
    var totalSpent: Float = 0.0
    
    var groupExpenses = [GroupExpense]()

    @IBOutlet weak var youOweLabel: UILabel!
    
    @IBOutlet weak var groupButton: RaisedButton!
    
    @IBOutlet weak var userButton: RaisedButton!
    
    
    @IBOutlet weak var mainBalance: UILabel!
    
    @IBOutlet weak var userImageView: AsyncImageView!
    
    @IBOutlet weak var helloLabel: UILabel!
    
    var user = User()
    var group = Group()
    var groupMembers = [User]()
    
    var alphaRef = FIRDatabaseReference.init()
    
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
                
        alphaRef = FIRDatabase.database().reference()
        
    
        
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
            helloLabel.text = "Welcome"
            helloLabel.alpha = 1
            print(currentUser.uid)
            
            if let userRef = alphaRef.child("users/\(currentUser.uid)") as FIRDatabaseReference? {
                
                userRef.observeEventType(.Value, withBlock: { (snapshot) in
                    
                    self.user = User.userFromFirebase(snapshot.value! as! NSDictionary)
                    
                    
                    self.mainBalance.text = "\(self.user.amountOwing) $"
                    self.helloLabel.text = "Hello, "
                    self.userButton.setTitle(self.user.name, forState: .Normal)
                    self.groupButton.setTitle(self.user.defaultGroupName, forState: .Normal)
                    self.userButton.alpha = 1
                    self.groupButton.alpha = 1
                    self.mainBalance.alpha = 1
                    self.youOweLabel.alpha = 1
                    
                    if let userId = self.user.userId as String? {
                        if let expensesRef = self.alphaRef.child("expenses/\(userId)") as FIRDatabaseReference? {
                            expensesRef.child("totalSpent").observeEventType(.Value, withBlock: { (totalSpentSpanshot) in
                                self.totalSpent = totalSpentSpanshot.value! as! Float
                                print("TOTAL SPENT\(self.totalSpent)")
                                self.mainBalance.text = "\(self.totalSpent)"
                            })
                            
                            expensesRef.observeEventType(.Value, withBlock: { (expSnapshot) in
                                print(expSnapshot.value!)
                                
                                self.expenses = Expense.expensesFromResults(expSnapshot.value! as! NSDictionary, ref: expSnapshot.ref)
                                
                                
                            })
                        }
                    }
                    
                    
                    if let groupId = self.user.defaultGroupId as String? {
//                        if let expensesRef = self.alphaRef.child("expenses/\(groupId)") as FIRDatabaseReference? {
//                            expensesRef.observeEventType(.Value, withBlock: { (expSnapshot) in
//                                self.expenses = GroupExpense.expensesFromFirebase(expSnapshot.value! as! NSDictionary, firebasereference: expSnapshot.ref)
//                            })
//                        }
                        
                        if let groupRef = self.alphaRef.child("groups/\(groupId)") as FIRDatabaseReference? {
                            groupRef.observeSingleEventOfType(.Value, withBlock: { (groupSnapshot) in
                                self.group = Group.groupFromFirebase(self.user.defaultGroupId, results: groupSnapshot.value! as! NSDictionary)
                                for member in self.group.members {
                                    if let memberRef = self.alphaRef.child("users/\(member)") as FIRDatabaseReference? {
                                        memberRef.observeEventType(.Value, withBlock: { (memberSnapshot) in
                                            self.groupMembers.append(User.userFromFirebase(memberSnapshot.value! as! NSDictionary))
                                        })
                                    }
                                }
                            })
                        }
                    }
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
        
    
        
    }

    func toListExpenses() {
        if let expensesListController = self.storyboard?.instantiateViewControllerWithIdentifier("expensesListController") as? ExpensesListController {
            expensesListController.expenses = self.groupExpenses
            expensesListController.groupName = self.group.name
            self.navigationController?.pushViewController(expensesListController, animated: true)
        }
    }
    
    func toAddExpenseCycle() {
        if let addExpenseVC = self.storyboard?.instantiateViewControllerWithIdentifier("addExpenseController") as? AddExpenseController {
            addExpenseVC.currentStep = AddExpenseStep.description
            addExpenseVC.expenseType = ExpenseType.user
            
            
            var newExpense = Expense()
            
            if let userId = self.user.userId as String? {
                newExpense.firebaseDBRef = alphaRef.child("expenses/\(userId)")
            }
            
            addExpenseVC.newExpense = newExpense
            self.navigationController?.pushViewController(addExpenseVC, animated: true)
        }
    }
    
//    func toAddExpenseCycle() {
//        if let addExpenseVC = self.storyboard?.instantiateViewControllerWithIdentifier("addExpenseController") as? AddExpenseController {
//            addExpenseVC.currentStep = AddExpenseStep.description
//            
//            var owing = [String : Float]()
//            owing.removeAll()
//            
//            for member in groupMembers {
//                owing[member.name] = member.amountOwing
//            }
//            
//            print(owing)
//            
//            var newExpense = GroupExpense()
//            newExpense.addedBy = user.name 
//            newExpense.group = user.defaultGroupName
//            newExpense.groupId = user.defaultGroupId
//            newExpense.groupMembers = groupMembers
//            newExpense.owing = owing
//            newExpense.firebaseDBRef = self.alphaRef
//            
//            addExpenseVC.newExpense = newExpense
//            self.navigationController?.pushViewController(addExpenseVC, animated: true)
//        }
//    }
    

}

