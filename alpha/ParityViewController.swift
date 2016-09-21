//
//  ParityViewController.swift
//  alpha
//
//  Created by Ezra Bathini on 17/07/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit


class ParityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var currentStep = AddExpenseStep.description
    
    var newGroupExpense = GroupExpense()
    var expenseType: ExpenseType = .group 
    
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
        
        
        print(newGroupExpense)
        
        
        view.backgroundColor = currentStep.toColor()
        
        option1.setTitleColor(MaterialColor.white, for: .normal)
        option1.titleLabel?.font = UIFont.systemFont(ofSize: 15) //UIFont.systemFont(ofSize: 15)
        option1.pulseColor = MaterialColor.blue.accent3
        option1.setTitle("Equally".localizedCapitalized, for: .normal)
        option1.tag = 201
        option1.addTarget(self, action: #selector(self.updateParityFromButton(_:)), for: .touchUpInside)
        
        option2.setTitleColor(MaterialColor.white, for: .normal)
        option2.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        option2.pulseColor = MaterialColor.blue.accent3
        option2.setTitle("Equally On All But You".localizedCapitalized, for: .normal)
        option2.tag = 202
        option2.addTarget(self, action: #selector(self.updateParityFromButton(_:)), for: .touchUpInside)
        
        option3.setTitleColor(MaterialColor.white, for: .normal)
        option3.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        option3.pulseColor = MaterialColor.blue.accent3
        option3.setTitle("Select Group Members".localizedCapitalized, for: .normal)
        option3.tag = 203
        option3.addTarget(self, action: #selector(self.showTableView), for: .touchUpInside)
        
        if newGroupExpense.groupMembers.count == 2 {
            for member in newGroupExpense.groupMembers {
                if member.userId != newGroupExpense.addedBy {
                    option2.setTitle("Spent On \(member.name.localizedCapitalized) ", for: .normal)
                }
            }
            option3.alpha = 0
            
        }
        nextButton.backgroundColor = MaterialColor.red.lighten1
        
        nextButton.alpha = 0
        nextButton.addTarget(self, action: #selector(self.toNextInAddExpenseCycle), for: .touchUpInside)
        nextButton.setTitleColor(MaterialColor.white, for: .normal)
        tableView.alpha = 0
        tableView.frame.size.height = CGFloat((Float(newGroupExpense.groupMembers.count) * 50))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = currentStep.toColor()
        
        backButton.setImage(MaterialIcon.arrowBack, for: .normal)
        
        tableView.layer.cornerRadius = 5
        tableView.layer.shadowOpacity = 0.5
        
        backButton.addTarget(self, action: #selector(AddExpenseController.backOneStep), for: .touchUpInside)
        
//        shareEquallySwitch.frame.origin.x = view.frame.width - 60
//        shareEquallySwitch.center.y = parityQuestionLabel.center.y
//        
//        shareEquallySwitch.tag = 100
//        shareEquallySwitch.delegate = self
        
//        view.addSubview(shareEquallySwitch)
        
        parityQuestionLabel.text = "Whom did you spend $\(newGroupExpense.billAmount) on?"
        
        
//        nextButton = FlatButton(frame: CGRectMake(self.view.frame.width - 100, parityQuestionLabel.frame.origin.y + parityQuestionLabel.frame.size.height + 8 , 60, 60))
//        backButton = FlatButton(frame: CGRectMake(self.view.frame.width - 180, parityQuestionLabel.frame.origin.y + parityQuestionLabel.frame.size.height + 8, 60, 60))
//        
//        nextButton.backgroundColor = MaterialColor.white
//        
//        if currentStep == .finish {
//            nextButton.setTitle("FINISH", for: .normal)
//        } else {
//            nextButton.setTitle("NEXT", for: .normal)
//        }
//        
//        
//        
//        nextButton.setTitleColor(MaterialColor.blue.accent1, for: .normal)
//        nextButton.titleLabel?.font = RobotoFont.regularWithSize(8)
//        nextButton.pulseColor = MaterialColor.blue.accent3
//        
//        nextButton.tintColor = MaterialColor.blue.accent3
//        
//        nextButton.layer.cornerRadius = 30
//        
//        nextButton.layer.shadowOpacity = 0.1
//        
//        nextButton.addTarget(self, action: #selector(ParityViewController.toNextInAddExpenseCycle), for: .TouchUpInside)
//        
//        nextButton.alpha = 1
//        
//        backButton.backgroundColor = MaterialColor.white
//        
//        backButton.setTitle("BACK", for: .normal)
//        backButton.setTitleColor(MaterialColor.blue.accent1, for: .normal)
//        backButton.titleLabel?.font = RobotoFont.regularWithSize(8)
//        backButton.layer.cornerRadius = 30
//        
//        backButton.addTarget(self, action: #selector(ParityViewController.backOneStep), for: .TouchUpInside)
        
        let image = UIImage(named: "ic_close_white")?.withRenderingMode(.automatic)
        let clearButton: FlatButton = FlatButton()
        clearButton.pulseColor = MaterialColor.grey.base
        clearButton.tintColor = MaterialColor.grey.base
        clearButton.setImage(image, for: .normal)
        clearButton.setImage(image, for: .highlighted)
        
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
//                for _ in newGroupExpense.groupMembers {
//                    parity.append(1)
//                }
//            } else {
//                self.tableView.alpha = 1
//                self.selectLabel.alpha = 1
//                let buttonsNewYPosition = self.tableView.frame.origin.y + self.tableView.frame.size.height + 10
//                self.nextButton.frame.origin.y = buttonsNewYPosition
//                self.backButton.frame.origin.y = buttonsNewYPosition
//                parity.removeAll()
//                for _ in newGroupExpense.groupMembers {
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
        for _ in newGroupExpense.groupMembers {
            parity.append(0)
        }
        self.tableView.alpha = 1
    }
    
    func updateParityFromButton(_ sender: FlatButton) {
        parity.removeAll()
        
        switch sender.tag {
        case 201:
            for _ in newGroupExpense.groupMembers {
                parity.append(1)
            }
        case 202:
            for member in newGroupExpense.groupMembers {
                if member.userId == newGroupExpense.addedBy {
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
    
    func updateParityFromTable(_ indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! ParitySelectionCell
        
        
        cell.isClicked = !(cell.isClicked!)
        
        if cell.isClicked == true {
            parity[(indexPath as NSIndexPath).row] = 1
        } else {
            parity[(indexPath as NSIndexPath).row] = 0
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
        

        
        newGroupExpense.parity.removeAll()
        newGroupExpense.spent.removeAll()
        
        var paritySum = 0
        
        for i in parity {
            paritySum = paritySum + i
        }
        
        for i in 0 ..< newGroupExpense.groupMembers.count {
            let member = newGroupExpense.groupMembers[i]
            let memberParity = parity[i]
            
            //parity
            newGroupExpense.parity[member.userId] = parity[i]
            
            //spent
            if member.userId == newGroupExpense.addedBy {
                newGroupExpense.spent[member.userId] = 1
            } else {
                newGroupExpense.spent[member.userId] = 0
            }
            
            //share
            if paritySum != 0 {
                newGroupExpense.share[member.userId] = newGroupExpense.billAmount * Float(memberParity) / Float(paritySum)
            }
            
            //settlemet
            if newGroupExpense.spent.count > 0 {
                if newGroupExpense.share[member.userId] != nil && newGroupExpense.spent[member.userId] != nil {
                    newGroupExpense.settlement[member.userId] = (newGroupExpense.billAmount * Float(newGroupExpense.spent[member.userId]!)) - newGroupExpense.share[member.userId]!
                }
            }
            
            //owing
            if newGroupExpense.settlement.count > 0 {
                if newGroupExpense.settlement[member.userId] != nil {
                    newGroupExpense.owing[member.userId] = newGroupExpense.owing[member.userId]! - newGroupExpense.settlement[member.userId]!
                }
            }
        }
        
        
        print(newGroupExpense)
        
        
        
        if let finishVC = self.storyboard?.instantiateViewController(withIdentifier: "finishViewController") as? FinishViewController {
            
            if paritySum == parity.count {
                finishVC.parityText = "shared equally"
            } else {
                finishVC.parityText = "spent on "
                for member in newGroupExpense.parity {
                    if member.1 == 1 {
                        finishVC.parityText = finishVC.parityText + member.0
                    }
                }
            }
            finishVC.expenseType = self.expenseType
            finishVC.newGroupExpense = self.newGroupExpense
            self.navigationController?.pushViewController(finishVC, animated: true)
        }
    }
    
    
    
    func backOneStep() {
        print("back button")
        navigationController?.popViewController(animated: true)
    }
    
    

    
    //MARK:- Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newGroupExpense.groupMembers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "parityCell", for: indexPath) as! ParitySelectionCell
        
        if let user = newGroupExpense.groupMembers[(indexPath as NSIndexPath).row] as User? {
            cell.user = user
            cell.isClicked = false
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        updateParityFromTable(indexPath)
        
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        updateParityFromTable(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
