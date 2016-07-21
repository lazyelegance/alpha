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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backOneStep() {
        print("back button")
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    func saveExpense()  {
        print("SAVING")
        
        let timzoneSeconds = NSTimeZone.localTimeZone().secondsFromGMT
        
        let currDate = NSDate().dateByAddingTimeInterval(Double(timzoneSeconds))
        
        print(newExpense)
        
        let firebaseUserRef = newExpense.firebaseDBRef.child("users")
        let firebaseGroupRef = newExpense.firebaseDBRef.child("groups").child(newExpense.groupId)
        let groupExpensesRef = newExpense.firebaseDBRef.child("expenses").child(newExpense.groupId)
        
        let key = groupExpensesRef.childByAutoId().key
        
        
        //alphaExpensesRef.child("expenses").updateChildValues([key : ["Total": 120.00, "addedBy": "ezra", "description": "some desription", "spent": ["ezra": 1, "ram": 0 ], "parity" : ["ezra" : 1, "ram": 1], "share": ["ezra": 60.00, "ram": 60.00 ], "settlemet": ["ezra": 60.00, "ram": -60.00 ]  ]])

        groupExpensesRef.updateChildValues([key : ["dateAdded": "\(currDate)","billAmount": newExpense.billAmount, "addedBy": newExpense.addedBy, "description": newExpense.description, "group": newExpense.group, "spent": newExpense.spent, "parity" : newExpense.parity, "share": newExpense.share, "settlement": newExpense.settlement, "owing": newExpense.owing  ]]) { (error, ref) in
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
        
        for member in newExpense.groupMembers {
            let currentUserRef = firebaseUserRef.child(member.userUID)
            let currentUserOwing = newExpense.owing[member.name]
            
            currentUserRef.child("amountOwing").setValue(currentUserOwing, withCompletionBlock: { (error, ref) in
                if error != nil {
                    print(error?.localizedDescription)
                } else {
                    print("Success saving \(member.name) owing amount")
                }
            })
        }

        
        
        
        self.navigationController?.popToRootViewControllerAnimated(true)
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
