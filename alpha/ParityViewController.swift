//
//  ParityViewController.swift
//  alpha
//
//  Created by Ezra Bathini on 17/07/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import Material

class ParityViewController: UIViewController, MaterialSwitchDelegate {
    var currentStep = AddExpenseStep.description
    
    var newExpense = Expense()
    
    var parityText = "Shared Equally (1:1)"
    
    var currAmountOwing = "0.00"
    var currUser = String()
    var currGroup = String()
    var currGroupMembers = [String]()

    var parity = [1,1]
   
    @IBOutlet weak var sharedEquallyLabel: UILabel!
    @IBOutlet weak var paidForOtherLabel: UILabel!
    @IBOutlet weak var paidForSelfLabel: UILabel!
    
    var nextButton: FlatButton!
    
    var backButton: FlatButton!
    
    let sharedEquallySwitch = MaterialSwitch(state: .On, style: .LightContent, size: .Large)
    let paidForOtherSwitch = MaterialSwitch(state: .Off, style: .LightContent, size: .Large)
    let paidForSelfSwitch = MaterialSwitch(state: .Off, style: .LightContent, size: .Large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = currentStep.toColor()
        
        CGRectMake(0, 0, 0, 0)
        
        
        sharedEquallySwitch.frame.origin.x = view.frame.width - 60
        sharedEquallySwitch.frame.origin.y = sharedEquallyLabel.frame.origin.y
        sharedEquallySwitch.tag = 100
        sharedEquallySwitch.delegate = self
        
        
        paidForOtherSwitch.frame.origin.x = view.frame.width - 60
        paidForOtherSwitch.frame.origin.y = paidForOtherLabel.frame.origin.y
        paidForOtherSwitch.tag = 101
        paidForOtherSwitch.delegate = self
        
        
        paidForSelfSwitch.frame.origin.x = view.frame.width - 60
        paidForSelfSwitch.frame.origin.y = paidForSelfLabel.frame.origin.y
        paidForSelfSwitch.tag = 102
        paidForSelfSwitch.delegate = self

        
        view.addSubview(sharedEquallySwitch)
        view.addSubview(paidForOtherSwitch)
        view.addSubview(paidForSelfSwitch)
        
        nextButton = FlatButton(frame: CGRectMake(self.view.frame.width - 100, paidForSelfLabel.frame.origin.y + paidForSelfLabel.frame.size.height + 8 , 60, 60))
        backButton = FlatButton(frame: CGRectMake(self.view.frame.width - 180, paidForSelfLabel.frame.origin.y + paidForSelfLabel.frame.size.height + 8, 60, 60))
        
        nextButton.backgroundColor = MaterialColor.white
        
        if currentStep == .finish {
            nextButton.setTitle("FINISH", forState: .Normal)
        } else {
            nextButton.setTitle("NEXT", forState: .Normal)
        }
        
        
        
        nextButton.setTitleColor(MaterialColor.blue.accent1, forState: .Normal)
        nextButton.titleLabel?.font = RobotoFont.regularWithSize(8)
        nextButton.pulseColor = MaterialColor.blue.accent3
        
        nextButton.tintColor = MaterialColor.blue.accent3
        
        nextButton.layer.cornerRadius = 30
        
        nextButton.layer.shadowOpacity = 0.1
        
        nextButton.addTarget(self, action: #selector(ParityViewController.toNextInAddExpenseCycle), forControlEvents: .TouchUpInside)
        
        nextButton.alpha = 1
        
        backButton.backgroundColor = MaterialColor.white
        
        backButton.setTitle("BACK", forState: .Normal)
        backButton.setTitleColor(MaterialColor.blue.accent1, forState: .Normal)
        backButton.titleLabel?.font = RobotoFont.regularWithSize(8)
        backButton.layer.cornerRadius = 30
        
        backButton.addTarget(self, action: #selector(ParityViewController.backOneStep), forControlEvents: .TouchUpInside)
        
        let image = UIImage(named: "ic_close_white")?.imageWithRenderingMode(.Automatic)
        let clearButton: FlatButton = FlatButton()
        clearButton.pulseColor = MaterialColor.grey.base
        clearButton.tintColor = MaterialColor.grey.base
        clearButton.setImage(image, forState: .Normal)
        clearButton.setImage(image, forState: .Highlighted)
        
        view.addSubview(nextButton)
        view.addSubview(backButton)
        
        parity = [1,1]

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Switch
    
    
    
    func materialSwitchStateChanged(control: MaterialSwitch) {
        print("control tag: \(control.tag)")
        
        switch control.tag {
        case 100:

            if control.on {
                self.parity.removeAll()
                self.parity = [1,1]
                paidForOtherSwitch.setSwitchState(.Off)
                paidForSelfSwitch.setSwitchState(.Off)
            }
        case 101:
            if control.on {
                self.parity.removeAll()
                self.parity = [0,1]
                sharedEquallySwitch.setSwitchState(.Off)
                paidForSelfSwitch.setSwitchState(.Off)
            }
        case 102:
            if control.on {
                self.parity.removeAll()
                self.parity = [1,0]
                paidForOtherSwitch.setSwitchState(.Off)
                sharedEquallySwitch.setSwitchState(.Off)
            }
            
            
        default:
            return
        }
        
    }
    
    func toNextInAddExpenseCycle()  {
        //
        self.newExpense = updateExpenseWithParity(newExpense, parity: self.parity)
        
        if let finishVC = self.storyboard?.instantiateViewControllerWithIdentifier("finishViewController") as? FinishViewController {
            finishVC.parityText = self.parityText
            finishVC.newExpense = self.newExpense
            self.navigationController?.pushViewController(finishVC, animated: true)
        }
    }
    
    
    
    func backOneStep() {
        print("back button")
        navigationController?.popViewControllerAnimated(true)
    }
    
    func updateExpenseWithParity(expense: Expense, parity: [Int]) -> Expense {
        
        var currExpense = expense        
        var parityDictionary: [String: Int] = [:]
        var shareDictionary: [String: Float] = [:]
        var spentDictionary: [String: Int] = [:]
        var settlementDictionary: [String: Float] = [:]
        
        parityDictionary.removeAll()
        shareDictionary.removeAll()
        spentDictionary.removeAll()
        settlementDictionary.removeAll()
        
        
        
        
        var paritySum = 0
        
        for item in parity {
            paritySum = paritySum + item
        }
        
        print(paritySum)
        
        if let user = expense.addedBy as? String, group = expense.group as? String, groupMembers = expense.groupMembers as? [String], amount = expense.billAmount as? Float {
            for (var i = 0; i < groupMembers.count; ++i) {
                let currentParity = parity[i]
                let currentMember = groupMembers[i]
                //let memberParity = [currentMember : currentParity]
                var memberSpent = 0
                
                if currentMember == user {
                    memberSpent = 1
                    
                }
                
                
                spentDictionary[currentMember] = memberSpent
                parityDictionary[currentMember] = currentParity
                
                if let currentMemberShare = amount * Float(currentParity) / Float(paritySum) as? Float {
                    print("current Member SHare: \(currentMemberShare)")
                   
                    if let currentMemberSettlement = Float(memberSpent) * amount - Float(currentMemberShare) as? Float {
                        print("current Member Settlemnt: \(currentMemberSettlement)")
                        let memberSettlement = [currentMember : currentMemberSettlement]
                        settlementDictionary[currentMember] = currentMemberSettlement
                        if let currMemberOwing = expense.owing[currentMember] as Float! {
                            currExpense.owing[currentMember] = currMemberOwing + currentMemberSettlement
                        }
                        
                    }
                    shareDictionary[currentMember] = currentMemberShare
                }
                
            }
        }

        currExpense.parity = parityDictionary
        currExpense.share = shareDictionary
        currExpense.settlement = settlementDictionary
        currExpense.spent = spentDictionary
        
        return currExpense
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
