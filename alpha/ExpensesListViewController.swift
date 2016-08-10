//
//  ExpensesListViewController.swift
//  alpha
//
//  Created by Ezra Bathini on 30/07/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import Material
import FirebaseDatabase

class ExpensesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var expenseType = ExpenseType.user
    
    var expenses = [Expense]()
    var expensesRef = FIRDatabaseReference()
    
    var groupExpenses = [GroupExpense]()
    var groupExpensesRef = FIRDatabaseReference()
    
    var groupName = String()
    var userName = String()
    

    @IBOutlet weak var headerDetail: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareview()
        preparetableview()
        getExpenses()
        prepareHeaderView()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func prepareview() {

        view.backgroundColor = MaterialColor.red.lighten1

    }
    
    private func preparetableview() {
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func prepareHeaderView() {
        
        
        switch self.expenseType {
        case .user:
            headerDetail.text = "for " + userName
        case .group:
            headerDetail.text = "for " + groupName
        }
    }
    
    private func getExpenses() {
        
        print(self.expenseType)
        self.expenses.removeAll()
        switch self.expenseType {
        case .user:
            expensesRef.observeEventType(.Value, withBlock: { (expSnapshot) in
                if expSnapshot.exists() {
                    self.expenses = Expense.expensesFromResults(expSnapshot.value! as! NSDictionary, ref: expSnapshot.ref)
                    print(self.expenses.count)
                    print(self.expenses)
                    self.tableView.reloadData()
                }
                
            })
        case .group:
            print(groupExpensesRef)
             groupExpensesRef.observeEventType(.Value, withBlock: { (grpExpSnapshot) in
                if grpExpSnapshot.exists() {
                    self.groupExpenses = GroupExpense.expensesFromFirebase(grpExpSnapshot.value! as! NSDictionary, firebasereference: grpExpSnapshot.ref)
                    self.tableView.reloadData()
                }
                
             })
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
    
    // MARK: - TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(expenses)
        switch expenseType {
        case .user:
            return expenses.count
        case .group:
            return groupExpenses.count
        }
    }
    
    /// Returns the number of sections.
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    /// Prepares the cells within the tableView.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        let cell: MaterialTableViewCell = MaterialTableViewCell(style: .Subtitle, reuseIdentifier: "expenseCell")
        
        switch expenseType {
        case .user:
            let expenseCell = tableView.dequeueReusableCellWithIdentifier("expenseCell", forIndexPath: indexPath) as! ExpenseCell
            if let expense = expenses[indexPath.row] as Expense? {
                expenseCell.expense = expense
                return expenseCell
            }
        case .group:
            
            let groupExpenseCell = tableView.dequeueReusableCellWithIdentifier("groupExpenseCell", forIndexPath: indexPath) as! GroupExpenseCell
            if let groupExpense = groupExpenses[indexPath.row] as GroupExpense? {
                groupExpenseCell.groupExpense = groupExpense
                return groupExpenseCell
            }
//            let groupExpense = groupExpenses[indexPath.row]
//            cell.selectionStyle = .None
//            cell.textLabel!.text = groupExpense.description
//            cell.textLabel!.font = RobotoFont.regular
//            
//            cell.detailTextLabel?.text = "\(groupExpense.billAmount)$"
//            cell.detailTextLabel!.font = RobotoFont.regular
//            cell.detailTextLabel!.textColor = MaterialColor.grey.darken1
//            cell.imageView?.image = UIImage(named: "purse")
//            cell.imageView?.image!.resize(toWidth: 20)
//            cell.imageView?.layer.masksToBounds = true
//            
//            cell.imageView!.layer.cornerRadius = 5
//            cell.imageView!.layer.borderColor = MaterialColor.white.CGColor
//            cell.imageView?.layer.borderWidth = 5
        }
 
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //to do
        //to profile view
        
    }

}
