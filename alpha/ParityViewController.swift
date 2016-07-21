//
//  ParityViewController.swift
//  alpha
//
//  Created by Ezra Bathini on 17/07/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import Material

class ParityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
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
    
    @IBOutlet weak var parityQuestionLabel: UILabel!
    
//    let shareEquallySwitch = MaterialSwitch(state: .On, style: .LightContent, size: .Large)
    
//    var nextButton: FlatButton!
//    
//    var backButton: FlatButton!
    
    @IBOutlet weak var nextButton: RaisedButton!

    @IBOutlet weak var option1: FlatButton!
    
    @IBOutlet weak var option2: FlatButton!
    
    @IBOutlet weak var option3: FlatButton!
    
    @IBOutlet weak var backButton: FabButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(newExpense)
        
        
        view.backgroundColor = currentStep.toColor()
        
        option1.setTitleColor(MaterialColor.white, forState: .Normal)
        option1.titleLabel?.font = RobotoFont.boldWithSize(15)
        option1.pulseColor = MaterialColor.blue.accent3
        option1.setTitle("Equally".capitalizedString, forState: .Normal)
        option1.tag = 201
        option1.addTarget(self, action: #selector(self.updateParityFromButton(_:)), forControlEvents: .TouchUpInside)
        
        option2.setTitleColor(MaterialColor.white, forState: .Normal)
        option2.titleLabel?.font = RobotoFont.boldWithSize(15)
        option2.pulseColor = MaterialColor.blue.accent3
        option2.setTitle("Equally On All But You".capitalizedString, forState: .Normal)
        option2.tag = 202
        option2.addTarget(self, action: #selector(self.updateParityFromButton(_:)), forControlEvents: .TouchUpInside)
        
        option3.setTitleColor(MaterialColor.white, forState: .Normal)
        option3.titleLabel?.font = RobotoFont.boldWithSize(15)
        option3.pulseColor = MaterialColor.blue.accent3
        option3.setTitle("Select Group Members".capitalizedString, forState: .Normal)
        option3.tag = 203
        option3.addTarget(self, action: #selector(self.showTableView), forControlEvents: .TouchUpInside)
        
        if newExpense.groupMembers.count == 2 {
            for member in newExpense.groupMembers {
                if member.name != newExpense.addedBy {
                    option2.setTitle("Spent On \(member.name.capitalizedString) ", forState: .Normal)
                }
            }
            option3.alpha = 0
            
        }
        nextButton.backgroundColor = MaterialColor.red.lighten1
        
        nextButton.alpha = 0
        nextButton.addTarget(self, action: #selector(self.toNextInAddExpenseCycle), forControlEvents: .TouchUpInside)
        nextButton.setTitleColor(MaterialColor.white, forState: .Normal)
        tableView.alpha = 0
        tableView.frame.size.height = CGFloat((Float(newExpense.groupMembers.count) * 50))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = currentStep.toColor()
        
        backButton.setImage(MaterialIcon.arrowBack, forState: .Normal)
        
        tableView.layer.cornerRadius = 5
        tableView.layer.shadowOpacity = 0.5
        
        backButton.addTarget(self, action: #selector(AddExpenseController.backOneStep), forControlEvents: .TouchUpInside)
        
//        shareEquallySwitch.frame.origin.x = view.frame.width - 60
//        shareEquallySwitch.center.y = parityQuestionLabel.center.y
//        
//        shareEquallySwitch.tag = 100
//        shareEquallySwitch.delegate = self
        
//        view.addSubview(shareEquallySwitch)
        
        parityQuestionLabel.text = "Whom did you spend $\(newExpense.billAmount) on?"
        
        
//        nextButton = FlatButton(frame: CGRectMake(self.view.frame.width - 100, parityQuestionLabel.frame.origin.y + parityQuestionLabel.frame.size.height + 8 , 60, 60))
//        backButton = FlatButton(frame: CGRectMake(self.view.frame.width - 180, parityQuestionLabel.frame.origin.y + parityQuestionLabel.frame.size.height + 8, 60, 60))
//        
//        nextButton.backgroundColor = MaterialColor.white
//        
//        if currentStep == .finish {
//            nextButton.setTitle("FINISH", forState: .Normal)
//        } else {
//            nextButton.setTitle("NEXT", forState: .Normal)
//        }
//        
//        
//        
//        nextButton.setTitleColor(MaterialColor.blue.accent1, forState: .Normal)
//        nextButton.titleLabel?.font = RobotoFont.regularWithSize(8)
//        nextButton.pulseColor = MaterialColor.blue.accent3
//        
//        nextButton.tintColor = MaterialColor.blue.accent3
//        
//        nextButton.layer.cornerRadius = 30
//        
//        nextButton.layer.shadowOpacity = 0.1
//        
//        nextButton.addTarget(self, action: #selector(ParityViewController.toNextInAddExpenseCycle), forControlEvents: .TouchUpInside)
//        
//        nextButton.alpha = 1
//        
//        backButton.backgroundColor = MaterialColor.white
//        
//        backButton.setTitle("BACK", forState: .Normal)
//        backButton.setTitleColor(MaterialColor.blue.accent1, forState: .Normal)
//        backButton.titleLabel?.font = RobotoFont.regularWithSize(8)
//        backButton.layer.cornerRadius = 30
//        
//        backButton.addTarget(self, action: #selector(ParityViewController.backOneStep), forControlEvents: .TouchUpInside)
        
        let image = UIImage(named: "ic_close_white")?.imageWithRenderingMode(.Automatic)
        let clearButton: FlatButton = FlatButton()
        clearButton.pulseColor = MaterialColor.grey.base
        clearButton.tintColor = MaterialColor.grey.base
        clearButton.setImage(image, forState: .Normal)
        clearButton.setImage(image, forState: .Highlighted)
        
//        view.addSubview(nextButton)
//        view.addSubview(backButton)
        
        parity = [1,1]

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Switch
    
    
//    
//    func materialSwitchStateChanged(control: MaterialSwitch) {
//        print("control tag: \(control.tag)")
//        
//        if control.tag == 100 {
//            if control.on {
//                self.tableView.alpha = 0
//                self.selectLabel.alpha = 0
//                let buttonsNewYPosition = self.parityQuestionLabel.frame.origin.y + self.parityQuestionLabel.frame.size.height + 10
//                self.nextButton.frame.origin.y = buttonsNewYPosition
//                self.backButton.frame.origin.y = buttonsNewYPosition
//                parity.removeAll()
//                for _ in newExpense.groupMembers {
//                    parity.append(1)
//                }
//            } else {
//                self.tableView.alpha = 1
//                self.selectLabel.alpha = 1
//                let buttonsNewYPosition = self.tableView.frame.origin.y + self.tableView.frame.size.height + 10
//                self.nextButton.frame.origin.y = buttonsNewYPosition
//                self.backButton.frame.origin.y = buttonsNewYPosition
//                parity.removeAll()
//                for _ in newExpense.groupMembers {
//                    parity.append(0)
//                }
//                tableView.reloadData()
//            }
//            
//        }
//        
//    }
    
    func showTableView() {
        parity.removeAll()
        for _ in newExpense.groupMembers {
            parity.append(0)
        }
        self.tableView.alpha = 1
    }
    
    func updateParityFromButton(sender: FlatButton) {
        parity.removeAll()
        
        switch sender.tag {
        case 201:
            for _ in newExpense.groupMembers {
                parity.append(1)
            }
        case 202:
            for member in newExpense.groupMembers {
                if member.name == newExpense.addedBy {
                    parity.append(0)
                } else {
                    parity.append(1)
                }
            }
        default:
            break
        }
        
        toNextInAddExpenseCycle()
    }
    
    func updateParityFromTable(indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ParitySelectionCell
        
        
        cell.isClicked = !(cell.isClicked!)
        
        if cell.isClicked == true {
            parity[indexPath.row] = 1
        } else {
            parity[indexPath.row] = 0
        }
        
        print(parity)
        
        var paritySum = 0
        
        for i in parity {
            paritySum = paritySum + i
        }
        
        if paritySum != parity.count && paritySum != 0 {
            self.nextButton.alpha = 1
        } else {
            self.nextButton.alpha = 0
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
        
        updateParityFromTable(indexPath)
        
        
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        updateParityFromTable(indexPath)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70   
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
