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


enum SegementButtonState {
    case total
    case thisMonth
    case thisWeek
    
    func titleString() -> String {
        switch self {
        case .total:
            return "in Total"
        case .thisMonth:
            return "This Month"
        case .thisWeek:
            return "This Week"
        }
    }
    
    func nextState() -> SegementButtonState {
        switch self {
        case .total:
            return .thisMonth
        case .thisMonth:
            return .thisWeek
        case .thisWeek:
            return .total
        }
    }
    
}

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
    var thisMonthSpent: Float = 0.0
    var thisWeekSpent: Float = 0.0
    var totals = [String : Float]()
    
    var groupExpenses = [GroupExpense]()

    @IBOutlet weak var youOweLabel: UILabel!
    
    @IBOutlet weak var groupButton: RaisedButton!
    
    @IBOutlet weak var userButton: RaisedButton!
    @IBOutlet weak var segmentButton: RaisedButton!
    
    @IBOutlet weak var mainBalance: UILabel!
    
    @IBOutlet weak var userImageView: AsyncImageView!
    
    @IBOutlet weak var helloLabel: UILabel!
    
    var user = User()
    var group = Group()
    var groupMembers = [User]()
    
    var alphaRef = FIRDatabaseReference.init()
    
    var segmentButtonState = SegementButtonState.total
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBar.hidden = true
        prepareView()
        prepareButtons()
        prepareMenu()
        
      
        
        alphaRef = FIRDatabase.database().reference()
        mainBalance.text = "0.0 $"
        mainBalance.font = RobotoFont.lightWithSize(50)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        flatMenu.close()
        if (FIRAuth.auth()?.currentUser) != nil {
            updateMainBalance()
        } else {
            showLoginScreen()
        }
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Prepare View
    
    private func prepareView() {
        view.backgroundColor = MaterialColor.indigo.accent3
    }
    
    
    
    private func prepareButtons() {
        segmentButton.backgroundColor = MaterialColor.indigo.accent4
        segmentButton.layer.shadowOpacity = 0.1
        segmentButton.addTarget(self, action: #selector(self.updateSpentField(_:)), forControlEvents: .TouchUpInside)
        
        userButton.backgroundColor = MaterialColor.indigo.accent4
        userButton.layer.shadowOpacity = 0.1
    }
    
    private func prepareMenu() {
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
        btn2.addTarget(self, action: #selector(self.toAddExpenseCycle), forControlEvents: .TouchUpInside)
        view.addSubview(btn2)
        
        
        btn3.setTitleColor(MaterialColor.white, forState: .Normal)
        btn3.titleLabel?.font = RobotoFont.boldWithSize(12)
        //        btn3.borderColor = MaterialColor.blueGrey.lighten1
        btn3.pulseColor = MaterialColor.blue.accent3
        //        btn3.borderWidth = 1
        btn3.setTitle("See Expenses".uppercaseString, forState: .Normal)
        btn3.addTarget(self, action: #selector(self.toListExpenses), forControlEvents: .TouchUpInside)
        view.addSubview(btn3)
        
        let btn4: FlatButton = FlatButton()
        btn4.setTitleColor(MaterialColor.blue.accent3, forState: .Normal)
        btn4.borderColor = MaterialColor.blue.accent3
        btn4.pulseColor = MaterialColor.blue.accent3
        btn4.borderWidth = 1
        btn4.setTitle("Item", forState: .Normal)
        btn4.addTarget(self, action: #selector(self.toUserGroups), forControlEvents: .TouchUpInside)
        view.addSubview(btn4)
        
        // Initialize the menu and setup the configuration options.
        
        flatMenu = Menu(origin: CGPointMake(view.bounds.width/2 - 60, view.bounds.height - height - spacing))
        flatMenu.direction = .Up
        flatMenu.spacing = 8
        flatMenu.itemSize = CGSizeMake(120, height)
        flatMenu.views = [btn1, btn2, btn3, btn4]
    }
    
    // MARK: - Query Firebase
    
    private func updateMainBalance() {
        if let currentUser = FIRAuth.auth()?.currentUser {
            helloLabel.text = "Welcome"
            helloLabel.alpha = 1
            
            print(currentUser.photoURL)

            
            if let userRef = alphaRef.child("users/\(currentUser.uid)") as FIRDatabaseReference? {
                
                userRef.child("photoURL").observeSingleEventOfType(.Value, withBlock:{ (photoSnapshot) in
                    if !(photoSnapshot.exists()) {
                        
                        //TEMP: get String from URL

                            userRef.child("photoURL").setValue("\(currentUser.photoURL!)")

                        
                        
                    }
                })
                
                
                userRef.observeEventType(.Value, withBlock: { (snapshot) in
                    
                    self.user = User.userFromFirebase(snapshot.value! as! NSDictionary)
                    
                    
                    self.mainBalance.text = "\(self.user.amountOwing) $"
                    self.helloLabel.text = "Hello, "
                    self.userButton.setTitle(self.user.name, forState: .Normal)
                    self.userButton.alpha = 1
                    
                    let timzoneSeconds = NSTimeZone.localTimeZone().secondsFromGMT
                    
                    let currDate = NSDate().dateByAddingTimeInterval(Double(timzoneSeconds))
                    
                    let formatter_mon = NSDateFormatter()
                    formatter_mon.dateFormat = "MM_yyyy"
                    let currmon = formatter_mon.stringFromDate(currDate)
                    
                    
                    
                    let formatter_week = NSDateFormatter()
                    formatter_week.dateFormat = "w_yyyy"
                    let currweek = formatter_week.stringFromDate(currDate)
                    
                    
                    if let userId = self.user.userId as String? {
                        if let expensesRef = self.alphaRef.child("expenses/\(userId)") as FIRDatabaseReference? {
                            
                            self.totals.removeAll()
                            expensesRef.child("totals").observeEventType(.Value, withBlock: { (totalssnapshot) in
                                self.totals = Expense.totalsFromResults(totalssnapshot.value! as! NSDictionary)
                                
                                if self.totals["total"] != nil {
                                    self.totalSpent = self.totals["total"] as Float!
                                }
                                
                                if self.totals[currmon] != nil {
                                    self.thisMonthSpent = self.totals[currmon] as Float!
                                }
                                
                                if self.totals[currweek] != nil {
                                    self.thisWeekSpent = self.totals[currweek] as Float!
                                }
                                
                                
                                self.segmentButton.setTitle(self.segmentButtonState.titleString(), forState: .Normal)
                                switch self.segmentButtonState {
                                case .total:
                                    self.mainBalance.text = "\(self.totalSpent)"
                                case .thisMonth:
                                    self.mainBalance.text = "\(self.thisMonthSpent)"
                                case .thisWeek:
                                    self.mainBalance.text = "\(self.thisWeekSpent)"
                                }
                                
                                self.segmentButton.alpha = 1
                                self.mainBalance.alpha = 1
                                self.youOweLabel.alpha = 1
                                
                            })
                            
                            
                            
                        }
                    }
                    
                    
                    if let groupId = self.user.defaultGroupId as String? {
                        
                        
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
        }
    }
    
    
    private func showLoginScreen() {
        if let loginViewController = self.storyboard!.instantiateViewControllerWithIdentifier("loginViewController") as? LoginViewController {
            self.navigationController?.pushViewController(loginViewController, animated: true)
        } else {
            print("cannot instantiate login")
        }
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
    
    
    func updateSpentField(sender: RaisedButton) {
        self.segmentButtonState = self.segmentButtonState.nextState()
        self.segmentButton.setTitle(self.segmentButtonState.titleString(), forState: .Normal)
        switch self.segmentButtonState {
        case .total:
            self.mainBalance.text = "\(self.totalSpent)"
        case .thisMonth:
            self.mainBalance.text = "\(self.thisMonthSpent)"
        case .thisWeek:
            self.mainBalance.text = "\(self.thisWeekSpent)"
        }

    }
    
    
    func toUserGroups() {
        if let groupMainViewController = self.storyboard?.instantiateViewControllerWithIdentifier("groupMainViewController") as? GroupMainViewController {
            groupMainViewController.firebaseRef = alphaRef
            groupMainViewController.currentUser = user
            groupMainViewController.groupId = user.defaultGroupId
            self.navigationController?.pushViewController(groupMainViewController, animated: true)
        }
    
        
    }

    func toListExpenses() {
        if let userId = self.user.userId as String? {
            if let expensesListViewController = self.storyboard?.instantiateViewControllerWithIdentifier("expensesListViewController") as? ExpensesListViewController {
                expensesListViewController.expenseType = .user
                expensesListViewController.expensesRef = self.alphaRef.child("expenses/\(userId)")
                self.navigationController?.pushViewController(expensesListViewController, animated: true)
            }
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

