//
//  FinishViewController.swift
//  alpha
//
//  Created by Ezra Bathini on 17/07/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import Material
import Firebase
import FirebaseDatabase

class FinishViewController: UIViewController {
    
    
    
    var parityText = "Shared Equally (1:1)"
    
    var newExpense = Expense()
    var newGroupExpense = GroupExpense()
    var expenseType: ExpenseType = .user

    @IBOutlet weak var headerView: MaterialView!
    @IBOutlet weak var backButton: FabButton!
    @IBOutlet weak var saveButton: RaisedButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var paritylabel: UILabel!
    
    @IBOutlet weak var restartButton: FlatButton!
    @IBOutlet weak var categoryLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareLabels()
        prepareButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func prepareView() {
        view.backgroundColor = MaterialColor.blue.lighten1
        headerView.backgroundColor = MaterialColor.blue.lighten2
    }
    private func prepareLabels() {
        switch expenseType {
        case .user:
            descriptionLabel.text = newExpense.description
            titleLabel.text = "$\(newExpense.billAmount)"
            paritylabel.alpha = 0
            categoryLabel.text = newExpense.category.uppercaseString
        case .group:
            descriptionLabel.text = newGroupExpense.description
            titleLabel.text = "$\(newGroupExpense.billAmount)"
            paritylabel.text = parityText
            categoryLabel.text = newGroupExpense.category.uppercaseString
        }
        
    }
    private func prepareButtons() {
        saveButton.backgroundColor = view.backgroundColor
        saveButton.setTitle("SAVE EXPENSE", forState: .Normal)
        backButton.setImage(MaterialIcon.arrowBack, forState: .Normal)
        
        backButton.addTarget(self, action: #selector(self.backOneStep), forControlEvents: .TouchUpInside)
        
        switch expenseType {
        case .user:
            saveButton.addTarget(self, action: #selector(self.saveExpense), forControlEvents: .TouchUpInside)
        case .group:
            saveButton.addTarget(self, action: #selector(self.saveGroupExpense), forControlEvents: .TouchUpInside)
        }
        
        saveButton.setTitleColor(MaterialColor.white, forState: .Normal)
        
        restartButton.setTitleColor(MaterialColor.white, forState: .Normal)
        restartButton.setTitle("START OVER", forState: .Normal)
    }
    
    // MARK: - Navigation
    
    func backOneStep() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func cancelAddingExpense(sender: AnyObject) {
        goBacktoMainViewController()
    }
    
    func goBacktoMainViewController() {
        
        switch expenseType {
        case .user:
            self.navigationController?.popToRootViewControllerAnimated(true)
        case .group:
            if ((self.navigationController?.viewControllers[1].isKindOfClass(GroupMainViewController)) == true) {
                self.navigationController?.popToViewController((self.navigationController?.viewControllers[1])!, animated: true)
            } else {
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        }
        
    }
    
    @IBAction func restartAddExpense(sender: AnyObject) {
        if ((self.navigationController?.viewControllers[expenseType.firstStep()].isKindOfClass(AddExpenseController)) == true) {
            self.navigationController?.popToViewController((self.navigationController?.viewControllers[expenseType.firstStep()])!, animated: true)
        } else {
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
// MARK: - SAVE
    
    func saveGroupExpense() {
        
        if self.expenseType == .group {
            let timzoneSeconds = NSTimeZone.localTimeZone().secondsFromGMT
            
            let currDate = NSDate().dateByAddingTimeInterval(Double(timzoneSeconds))
            
            let firebaseUserRef = newGroupExpense.firebaseDBRef.child("users")
            let firebaseGroupRef = newGroupExpense.firebaseDBRef.child("groups").child(newGroupExpense.groupId)
            let groupExpensesRef = newGroupExpense.firebaseDBRef.child("groupExpenses").child(newGroupExpense.groupId)
            let grpExpTotalsRef = groupExpensesRef.child("totals")
            let key = groupExpensesRef.childByAutoId().key
            
            groupExpensesRef.updateChildValues([key : ["dateAdded": "\(currDate)","billAmount": newGroupExpense.billAmount, "addedBy": newGroupExpense.addedBy, "description": newGroupExpense.description, "group": newGroupExpense.group, "spent": newGroupExpense.spent, "parity" : newGroupExpense.parity, "share": newGroupExpense.share, "settlement": newGroupExpense.settlement, "owing": newGroupExpense.owing, "category" : newGroupExpense.category  ]]) { (error, ref) in
                if error != nil {
                    print(error?.localizedDescription)
                } else {
                    print("Success Saving Expense")
                }
            }
            
            
            
            grpExpTotalsRef.observeSingleEventOfType(.Value, withBlock: { (grptotals) in
                if grptotals.exists() {
                    if let totals = GroupExpense.totalsFromResults(grptotals.value! as! NSDictionary) as [String: AnyObject]? {
                        
                        if let currentTotalSpent = totals["totalSpent"] as? Float {
                            let newTotalSpent = currentTotalSpent + self.newExpense.billAmount
                            grpExpTotalsRef.child("totalSpent").setValue(newTotalSpent)
                        } else {
                            grpExpTotalsRef.child("total").setValue(self.newExpense.billAmount)
                        }
                        if let spentDictionery = totals["spent"] as? [String: Float] {
                            if let currentUserSpent = spentDictionery[self.newGroupExpense.addedBy] as Float? {
                                let newTotalSpent = currentUserSpent + self.newExpense.billAmount
                                grpExpTotalsRef.child("spent/\(self.newGroupExpense.addedBy)").setValue(newTotalSpent)
                            } else {
                                grpExpTotalsRef.child("spent/\(self.newGroupExpense.addedBy)").setValue(self.newGroupExpense.billAmount)
                            }
                        } else {
                            grpExpTotalsRef.child("spent/\(self.newGroupExpense.addedBy)").setValue(self.newGroupExpense.billAmount)
                        }
                        
                        grpExpTotalsRef.child("owing").setValue(self.newGroupExpense.owing)
                        
                    }
                } else {
                    grpExpTotalsRef.child("owing").setValue(self.newGroupExpense.owing)
                    grpExpTotalsRef.child("spent/\(self.newGroupExpense.addedBy)").setValue(self.newGroupExpense.billAmount)
                    grpExpTotalsRef.child("total").setValue(self.newExpense.billAmount)
                }
            })
            
            firebaseGroupRef.child("lastExpense").setValue(key) { (error, ref) in
                if error != nil {
                    print(error?.localizedDescription)
                } else {
                    print("Success Saving Last Expense To Group")
                }
            }
            
            for member in newGroupExpense.groupMembers {
                let currentUserRef = firebaseUserRef.child(member.userId)
                let currentUserOwing = newGroupExpense.owing[member.name]
                
                currentUserRef.child("amountOwing").setValue(currentUserOwing, withCompletionBlock: { (error, ref) in
                    if error != nil {
                        print(error?.localizedDescription)
                    } else {
                        print("Success saving \(member.name) owing amount")
                    }
                })
            }
            
        }
        
        goBacktoMainViewController()
    }
    

    
    func saveExpense() {
        

        let timzoneSeconds = NSTimeZone.localTimeZone().secondsFromGMT
        
        let currDate = NSDate().dateByAddingTimeInterval(Double(timzoneSeconds))
        
        let formatter_mon = NSDateFormatter()
        formatter_mon.dateFormat = "MM_yyyy"
        let currmon = "m_" + formatter_mon.stringFromDate(currDate)

        let formatter_week = NSDateFormatter()
        formatter_week.dateFormat = "w_yyyy"
        let currweek = "w_" + formatter_week.stringFromDate(currDate)
        
        if self.expenseType == .user {
            let userExpensesRef = newExpense.firebaseDBRef
            
            let key = userExpensesRef.childByAutoId().key
            
            userExpensesRef.updateChildValues([key : ["description": newExpense.description, "billAmount": newExpense.billAmount, "category" : newExpense.category, "dateAdded" : "\(currDate)"]]) { (error, ref) in
                if error != nil {
                    print(error?.localizedDescription)
                    return
                }
                
                print("SuCESSS")
            }
            
            
            
            
            userExpensesRef.child("totals").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                if snapshot.exists() {
                    if let totals = Expense.totalsFromResults(snapshot.value! as! NSDictionary) as [String: Float]? {
                        
                        if let currentTotalSpent = totals["total"] as Float? {
                            let newTotalSpent = currentTotalSpent + self.newExpense.billAmount
                            userExpensesRef.child("totals/total").setValue(newTotalSpent)
                        }
                        
                        if totals[currmon] != nil {
                            if let currentMonSpent = totals[currmon] as Float? {
                                let newMonSpent = currentMonSpent + self.newExpense.billAmount
                                userExpensesRef.child("totals/\(currmon)").setValue(newMonSpent)
                            }
                        } else {
                            userExpensesRef.child("totals/\(currmon)").setValue(self.newExpense.billAmount)
                        }
                        
                        if totals[currweek] != nil {
                            if let currentMonSpent = totals[currweek] as Float? {
                                let newMonSpent = currentMonSpent + self.newExpense.billAmount
                                userExpensesRef.child("totals/\(currweek)").setValue(newMonSpent)
                            }
                        } else {
                            userExpensesRef.child("totals/\(currweek)").setValue(self.newExpense.billAmount)
                        }
                        
                    }
                } else {
                    let newTotalSpent = self.newExpense.billAmount
                    userExpensesRef.child("totals/total").setValue(newTotalSpent)
                    userExpensesRef.child("totals/\(currweek)").setValue(newTotalSpent)
                    userExpensesRef.child("totals/\(currmon)").setValue(newTotalSpent)
                }
                
                
            })
            let category = self.newExpense.category
            let categoryRef = userExpensesRef.child("categories/\(category)")
            
            categoryRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                if snapshot.exists() {
                    if let categoryDetail = Expense.categoryFromResults(snapshot.value! as! NSDictionary) as [String: Float]? {
                        
                        if let currentTotalSpent = categoryDetail["total"] as Float? {
                            let newTotalSpent = currentTotalSpent + self.newExpense.billAmount
                            categoryRef.child("total").setValue(newTotalSpent)
                        }
                        
                        if categoryDetail[currmon] != nil {
                            if let currentMonSpent = categoryDetail[currmon] as Float? {
                                let newMonSpent = currentMonSpent + self.newExpense.billAmount
                                categoryRef.child("\(currmon)").setValue(newMonSpent)
                            }
                        } else {
                            categoryRef.child("\(currmon)").setValue(self.newExpense.billAmount)
                        }
                        
                        if categoryDetail[currweek] != nil {
                            if let currentMonSpent = categoryDetail[currweek] as Float? {
                                let newMonSpent = currentMonSpent + self.newExpense.billAmount
                                categoryRef.child("\(currweek)").setValue(newMonSpent)
                            }
                        } else {
                            categoryRef.child("\(currweek)").setValue(self.newExpense.billAmount)
                        }
                        
                    }
                } else {
                    let newTotalSpent = self.newExpense.billAmount
                    
                    categoryRef.child("total").setValue(newTotalSpent)
                    categoryRef.child("\(currweek)").setValue(newTotalSpent)
                    categoryRef.child("\(currmon)").setValue(newTotalSpent)
                }
                
                
            })
            

        }
        
        goBacktoMainViewController()

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
