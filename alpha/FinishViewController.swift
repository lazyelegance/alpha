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
    
    var newExpense = Expense(desc: "new")
    
    
    var nextButton: FlatButton!
    
    var backButton: FlatButton!

    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var billAmountLabel: UILabel!
    
    
    @IBOutlet weak var paritylabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = AddExpenseStep.finish.toColor()
        
        descriptionLabel.text = newExpense.description
        billAmountLabel.text = "$ \(newExpense.billAmount)"
        paritylabel.text = parityText
        
        
        nextButton = FlatButton(frame: CGRectMake(self.view.frame.width - 100, paritylabel.frame.origin.y + paritylabel.frame.size.height + 8 , 60, 60))
        backButton = FlatButton(frame: CGRectMake(self.view.frame.width - 180, paritylabel.frame.origin.y + paritylabel.frame.size.height + 8, 60, 60))

        nextButton.backgroundColor = MaterialColor.white
        
        nextButton.setTitle("🏁", forState: .Normal)
        
        
        nextButton.setTitleColor(MaterialColor.blue.accent1, forState: .Normal)
        nextButton.titleLabel?.font = RobotoFont.regularWithSize(8)
        nextButton.pulseColor = MaterialColor.blue.accent3
        
        nextButton.tintColor = MaterialColor.blue.accent3
        
        nextButton.layer.cornerRadius = 30
        
        nextButton.layer.shadowOpacity = 0.1
        
        nextButton.addTarget(self, action: #selector(FinishViewController.saveExpense), forControlEvents: .TouchUpInside)

        
        backButton.backgroundColor = MaterialColor.white
        
        backButton.setTitle("🔙", forState: .Normal)
        backButton.setTitleColor(MaterialColor.blue.accent1, forState: .Normal)
        backButton.titleLabel?.font = RobotoFont.regularWithSize(8)
        backButton.layer.cornerRadius = 30
        
        backButton.addTarget(self, action: #selector(FinishViewController.restartAddExpense), forControlEvents: .TouchUpInside)
        
        let image = UIImage(named: "ic_close_white")?.imageWithRenderingMode(.Automatic)
        let clearButton: FlatButton = FlatButton()
        clearButton.pulseColor = MaterialColor.grey.base
        clearButton.tintColor = MaterialColor.grey.base
        clearButton.setImage(image, forState: .Normal)
        clearButton.setImage(image, forState: .Highlighted)
        
        
        view.addSubview(nextButton)
        view.addSubview(backButton)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func saveExpense()  {
        print("SAVING")
        
        let timzoneSeconds = NSTimeZone.localTimeZone().secondsFromGMT
        
        let currDate = NSDate().dateByAddingTimeInterval(Double(timzoneSeconds))
        
        print(newExpense)
        
        let key = newExpense.firebaseDBRef.child("expenses").childByAutoId().key
        
        
        //alphaExpensesRef.child("expenses").updateChildValues([key : ["Total": 120.00, "addedBy": "ezra", "description": "some desription", "spent": ["ezra": 1, "ram": 0 ], "parity" : ["ezra" : 1, "ram": 1], "share": ["ezra": 60.00, "ram": 60.00 ], "settlemet": ["ezra": 60.00, "ram": -60.00 ]  ]])

        newExpense.firebaseDBRef.child("expenses").updateChildValues([key : ["dateAdded": "\(currDate)","Total": newExpense.billAmount, "addedBy": newExpense.addedBy, "description": newExpense.description, "group": newExpense.group, "spent": newExpense.spent, "parity" : newExpense.parity, "share": newExpense.share, "settlement": newExpense.settlement  ]]) { (error, ref) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                print("SUCCESSSSSS")
            }
        }
        
        //
    }
    
    func restartAddExpense() {
        //
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
