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

    @IBOutlet weak var backButton: FabButton!
    @IBOutlet weak var saveButton: RaisedButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var paritylabel: UILabel!
    

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
        view.backgroundColor = AddExpenseStep.finish.toColor()
    }
    private func prepareLabels() {
        switch expenseType {
        case .user:
            descriptionLabel.text = newExpense.description
            titleLabel.text = "You are about to add expense of $\(newExpense.billAmount)"
            paritylabel.text = newExpense.category
        case .group:
            descriptionLabel.text = newGroupExpense.description
            titleLabel.text = "You are about to add expense of $\(newGroupExpense.billAmount)"
            paritylabel.text = parityText
        }
        
    }
    private func prepareButtons() {
        saveButton.backgroundColor = view.backgroundColor
        saveButton.setTitle("SAVE EXPENSE", forState: .Normal)
        backButton.setImage(MaterialIcon.arrowBack, forState: .Normal)
        
        backButton.addTarget(self, action: #selector(self.backOneStep), forControlEvents: .TouchUpInside)
        saveButton.addTarget(self, action: #selector(self.saveExpense), forControlEvents: .TouchUpInside)
        saveButton.setTitleColor(MaterialColor.white, forState: .Normal)
    }
    
    
    
    func backOneStep() {
        print("back button")
        navigationController?.popViewControllerAnimated(true)
    }
    

    
    func saveExpense() {
        

        let timzoneSeconds = NSTimeZone.localTimeZone().secondsFromGMT
        
        let currDate = NSDate().dateByAddingTimeInterval(Double(timzoneSeconds))
        
        let formatter_mon = NSDateFormatter()
        formatter_mon.dateFormat = "MM_yyyy"
        let currmon = formatter_mon.stringFromDate(currDate)

        let formatter_week = NSDateFormatter()
        formatter_week.dateFormat = "w_yyyy"
        let currweek = formatter_week.stringFromDate(currDate)
        
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
                            
                            userExpensesRef.child("totals/\(currweek)").setValue(newTotalSpent)
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
                        
                    } else {
                        let newTotalSpent = self.newExpense.billAmount
                        userExpensesRef.child("totals/total").setValue(newTotalSpent)
                        userExpensesRef.child("totals/\(currweek)").setValue(newTotalSpent)
                        userExpensesRef.child("totals/\(currmon)").setValue(newTotalSpent)
                    }
                }
                
                
            })
            

        } else if self.expenseType == .group {
            let firebaseUserRef = newGroupExpense.firebaseDBRef.child("users")
            let firebaseGroupRef = newGroupExpense.firebaseDBRef.child("groups").child(newGroupExpense.groupId)
            let groupExpensesRef = newGroupExpense.firebaseDBRef.child("groupExpenses").child(newGroupExpense.groupId)
            
            let key = groupExpensesRef.childByAutoId().key

            groupExpensesRef.updateChildValues([key : ["dateAdded": "\(currDate)","billAmount": newGroupExpense.billAmount, "addedBy": newGroupExpense.addedBy, "description": newGroupExpense.description, "group": newGroupExpense.group, "spent": newGroupExpense.spent, "parity" : newGroupExpense.parity, "share": newGroupExpense.share, "settlement": newGroupExpense.settlement, "owing": newGroupExpense.owing  ]]) { (error, ref) in
                if error != nil {
                    print(error?.localizedDescription)
                } else {
                    print("Success Saving Expense")
                }
            }
            
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
        
        self.navigationController?.popToRootViewControllerAnimated(true)

    }
    
    
    func saveGroupExpense()  {
        print("SAVING")

        //TO DO
        
    }
    
    func restartAddExpense() {
        //
        if ((self.navigationController?.viewControllers[1].isKindOfClass(AddExpenseController)) == true) {
            self.navigationController?.popToViewController((self.navigationController?.viewControllers[1])!, animated: true)
        }
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
