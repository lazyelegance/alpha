//
//  ParityViewController.swift
//  alpha
//
//  Created by Ezra Bathini on 17/07/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import Material

class ParityViewController: UIViewController, MaterialSwitchDelegate, UITableViewDataSource, UITableViewDelegate {
    var currentStep = AddExpenseStep.description
    
    var newExpense = Expense()
    
    var parityText = "Shared Equally (1:1)"
    
    var currAmountOwing = "0.00"
    var currUser = String()
    var currGroup = String()
    var currGroupMembers = [String]()

    var parity = [Int]()
   
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var selectLabel: UILabel!
    
    @IBOutlet weak var shareEquallyQuestionLabel: UILabel!
    
    let shareEquallySwitch = MaterialSwitch(state: .On, style: .LightContent, size: .Large)
    
    var nextButton: FlatButton!
    
    var backButton: FlatButton!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(newExpense)
        parity.removeAll()
        for _ in newExpense.groupMembers {
            parity.append(1)
        }
        
        updateParity(NSIndexPath(index: 0))
            
            
        view.backgroundColor = currentStep.toColor()
        
        
        tableView.alpha = 0
        tableView.frame.size.height = CGFloat((Float(newExpense.groupMembers.count) * 50))
        tableView.delegate = self
        tableView.dataSource = self
        
        shareEquallySwitch.frame.origin.x = view.frame.width - 60
        shareEquallySwitch.center.y = shareEquallyQuestionLabel.center.y
        
        shareEquallySwitch.tag = 100
        shareEquallySwitch.delegate = self
        
        view.addSubview(shareEquallySwitch)
        
        shareEquallyQuestionLabel.text = "Do you want to split $\(newExpense.billAmount) equally?"
        selectLabel.text = "Select group members to split $\(newExpense.billAmount) with"
        
        nextButton = FlatButton(frame: CGRectMake(self.view.frame.width - 100, shareEquallyQuestionLabel.frame.origin.y + shareEquallyQuestionLabel.frame.size.height + 8 , 60, 60))
        backButton = FlatButton(frame: CGRectMake(self.view.frame.width - 180, shareEquallyQuestionLabel.frame.origin.y + shareEquallyQuestionLabel.frame.size.height + 8, 60, 60))
        
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
        
        if control.tag == 100 {
            if control.on {
                self.tableView.alpha = 0
                self.selectLabel.alpha = 0
                let buttonsNewYPosition = self.shareEquallyQuestionLabel.frame.origin.y + self.shareEquallyQuestionLabel.frame.size.height + 10
                self.nextButton.frame.origin.y = buttonsNewYPosition
                self.backButton.frame.origin.y = buttonsNewYPosition
                parity.removeAll()
                for _ in newExpense.groupMembers {
                    parity.append(1)
                }
            } else {
                self.tableView.alpha = 1
                self.selectLabel.alpha = 1
                let buttonsNewYPosition = self.tableView.frame.origin.y + self.tableView.frame.size.height + 10
                self.nextButton.frame.origin.y = buttonsNewYPosition
                self.backButton.frame.origin.y = buttonsNewYPosition
                parity.removeAll()
                for _ in newExpense.groupMembers {
                    parity.append(0)
                }
                tableView.reloadData()
            }
            
        }
        
    }
    
    func toNextInAddExpenseCycle()  {
        
        //Update Expense

        
        newExpense.parity.removeAll()
        newExpense.spent.removeAll()
        
        var paritySum = 0
        
        for i in parity {
            paritySum = paritySum + i
        }
        
        for i in 0 ..< newExpense.groupMembers.count {
            let member = newExpense.groupMembers[i]
            let memberParity = parity[i]
            
            //parity
            newExpense.parity[member.name] = parity[i]
            
            //spent
            if member.name == newExpense.addedBy {
                newExpense.spent[member.name] = 1
            } else {
                newExpense.spent[member.name] = 0
            }
            
            //share
            if paritySum != 0 {
                newExpense.share[member.name] = newExpense.billAmount * Float(memberParity) / Float(paritySum)
            }
            
            //settlemet
            if newExpense.spent.count > 0 {
                if newExpense.share[member.name] != nil && newExpense.spent[member.name] != nil {
                    newExpense.settlement[member.name] = (newExpense.billAmount * Float(newExpense.spent[member.name]!)) - newExpense.share[member.name]!
                }
            }
            
            //owing
            if newExpense.settlement.count > 0 {
                if newExpense.settlement[member.name] != nil {
                    newExpense.owing[member.name] = newExpense.owing[member.name]! - newExpense.settlement[member.name]!
                }
            }
        }
        
        
        print(newExpense)
        
        
        
        if let finishVC = self.storyboard?.instantiateViewControllerWithIdentifier("finishViewController") as? FinishViewController {
            
            if paritySum == parity.count {
                finishVC.parityText = "shared equally"
            } else {
                finishVC.parityText = "spent on "
                for member in newExpense.parity {
                    if member.1 == 1 {
                        finishVC.parityText = finishVC.parityText + member.0
                    }
                }
            }
            
            finishVC.newExpense = self.newExpense
            self.navigationController?.pushViewController(finishVC, animated: true)
        }
    }
    
    
    
    func backOneStep() {
        print("back button")
        navigationController?.popViewControllerAnimated(true)
    }
    
    func prepareParity() {
        
    }

    
    //MARK:- Table View
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newExpense.groupMembers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("parityCell", forIndexPath: indexPath) as! ParitySelectionCell
        
        if let user = newExpense.groupMembers[indexPath.row] as User? {
            cell.user = user
            cell.isClicked = false
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        updateParity(indexPath)
        
        
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        updateParity(indexPath)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    
    func updateParity(indexPath: NSIndexPath) {
        
        if !shareEquallySwitch.on {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! ParitySelectionCell
            
            
            cell.isClicked = !(cell.isClicked!)
            
            if cell.isClicked == true {
                parity[indexPath.row] = 1
            } else {
                parity[indexPath.row] = 0
            }
        }
        
        print(parity)
        
        
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
