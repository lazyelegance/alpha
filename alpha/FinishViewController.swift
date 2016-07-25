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
        
        view.backgroundColor = AddExpenseStep.finish.toColor()
        
        descriptionLabel.text = newExpense.description
        titleLabel.text = "You are about to add expense of $\(newExpense.billAmount)"
        paritylabel.text = parityText
        
        saveButton.backgroundColor = view.backgroundColor
        saveButton.setTitle("SAVE EXPENSE", forState: .Normal)
        backButton.setImage(MaterialIcon.arrowBack, forState: .Normal)
        
        backButton.addTarget(self, action: #selector(self.backOneStep), forControlEvents: .TouchUpInside)
        saveButton.addTarget(self, action: #selector(self.saveExpense), forControlEvents: .TouchUpInside)
        saveButton.setTitleColor(MaterialColor.white, forState: .Normal)

        // Do any additional setup after loading the view.
        
        getTotalSpent(newExpense.firebaseDBRef)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backOneStep() {
        print("back button")
        navigationController?.popViewControllerAnimated(true)
    }
    
    func getTotalSpent(ref: FIRDatabaseReference) -> Float {
        ref.child("totalSpent").observeSingleEventOfType(.Value) { (snapshot) in
            return snapshot.value! as! Float
        }
        return -1
    }
    
    func saveExpense() {
        //
        let timzoneSeconds = NSTimeZone.localTimeZone().secondsFromGMT
        
        let currDate = NSDate().dateByAddingTimeInterval(Double(timzoneSeconds))
        
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
            
            userExpensesRef.child("totalSpent").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                let previousTotalSpent = snapshot.value! as! Float
                let currentTotalSpent = previousTotalSpent + self.newExpense.billAmount
                userExpensesRef.child("totalSpent").setValue(currentTotalSpent, withCompletionBlock: { (error, ref) in
                    if error != nil {
                        print(error?.localizedDescription)
                        return
                    }
                    
                    print("SuCESSS")
                })
            })
            

        } else if self.expenseType == .group {
            let firebaseUserRef = newGroupExpense.firebaseDBRef.child("users")
            let firebaseGroupRef = newGroupExpense.firebaseDBRef.child("groups").child(newGroupExpense.groupId)
            let groupExpensesRef = newGroupExpense.firebaseDBRef.child("groupExpenses").child(newGroupExpense.groupId)
            
            let key = groupExpensesRef.childByAutoId().key
            
            
            //alphaExpensesRef.child("expenses").updateChildValues([key : ["Total": 120.00, "addedBy": "ezra", "description": "some desription", "spent": ["ezra": 1, "ram": 0 ], "parity" : ["ezra" : 1, "ram": 1], "share": ["ezra": 60.00, "ram": 60.00 ], "settlemet": ["ezra": 60.00, "ram": -60.00 ]  ]])
            
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
        
        
        
        print(newExpense)
        
        
        
        
        
        
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
