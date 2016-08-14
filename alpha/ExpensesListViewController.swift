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
import FirebaseAuth

class ExpensesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ExpenseCellDelegate, GroupExpenseCellDelegate {
    
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
        view.backgroundColor = MaterialColor.amber.base
        if expenseType == .group {
            view.backgroundColor = MaterialColor.teal.base
        }
    }
    
    private func preparetableview() {
        
        tableView.backgroundColor = MaterialColor.clear
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
        
        self.expenses.removeAll()
        switch self.expenseType {
        case .user:
            expensesRef.observeEventType(.Value, withBlock: { (expSnapshot) in
                if expSnapshot.exists() {
                    self.expenses = Expense.expensesFromResults(expSnapshot.value! as! NSDictionary, ref: expSnapshot.ref)
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
                expenseCell.backgroundColor = MaterialColor.amber.lighten1
                if indexPath.row % 2 == 1 {
                   expenseCell.backgroundColor = MaterialColor.amber.lighten2
                }
                expenseCell.expense = expense
                expenseCell.expenseCellDelegate = self
                return expenseCell
            }
        case .group:
            
            let groupExpenseCell = tableView.dequeueReusableCellWithIdentifier("groupExpenseCell", forIndexPath: indexPath) as! GroupExpenseCell
            if let groupExpense = groupExpenses[indexPath.row] as GroupExpense? {
                groupExpenseCell.backgroundColor = MaterialColor.teal.lighten1
                if indexPath.row % 2 == 1 {
                    groupExpenseCell.backgroundColor = MaterialColor.teal.lighten2
                }
                groupExpenseCell.groupExpense = groupExpense
                groupExpenseCell.groupExpenseCellDelegate = self
                
                return groupExpenseCell
            }
        }
 
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch expenseType {
        case .user:
            if let expenseCell = tableView.cellForRowAtIndexPath(indexPath) as? ExpenseCell {
                expenseCell.toggleEditStack()
            }
        case .group:
            if let groupExpenseCell = tableView.cellForRowAtIndexPath(indexPath) as? GroupExpenseCell {
                groupExpenseCell.toggleEditStack()
            }
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        switch expenseType {
        case .user:
            if let expenseCell = tableView.cellForRowAtIndexPath(indexPath) as? ExpenseCell {
                expenseCell.toggleEditStack()
            }
        case .group:
            if let groupExpenseCell = tableView.cellForRowAtIndexPath(indexPath) as? GroupExpenseCell {
                groupExpenseCell.toggleEditStack()
            }
        }
    }
    
    
    // MARK: - DELETE EXPENSE
    
    func deleteUserExpense(expense: Expense) {
        expensesRef.child(expense.expenseId).removeValueWithCompletionBlock { (error, ref) in
            if error != nil {
                print(error?.localizedDescription)
            }
        }

        expensesRef.child("totals").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if snapshot.exists() {
                if let totals = Expense.totalsFromResults(snapshot.value! as! NSDictionary) as [String: Float]? {

                    if let currentTotalSpent = totals["total"] as Float? {
                        let newTotalSpent = currentTotalSpent - expense.billAmount
                        self.expensesRef.child("totals/total").setValue(newTotalSpent)
                    }

                    if totals[expense.month] != nil {
                        if let currentMonSpent = totals[expense.month] as Float? {
                            let newMonSpent = currentMonSpent - expense.billAmount
                            self.expensesRef.child("totals/\(expense.month)").setValue(newMonSpent)
                        }
                    }

                    if totals[expense.week] != nil {
                        if let currentMonSpent = totals[expense.week] as Float? {
                            let newMonSpent = currentMonSpent - expense.billAmount
                            self.expensesRef.child("totals/\(expense.week)").setValue(newMonSpent)
                        }
                    }
                    
                }
            }
        })
        
        expensesRef.child("categories/\(expense.category)").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if snapshot.exists() {
                print(snapshot)
                print("categories/\(expense.category)/\(expense.month)")
                if let totals = Expense.categoryFromResults(snapshot.value! as! NSDictionary) as [String: Float]? {
                    
                    if let currentTotalSpent = totals["total"] as Float? {
                        let newTotalSpent = currentTotalSpent - expense.billAmount
                        self.expensesRef.child("categories/\(expense.category)/total").setValue(newTotalSpent)
                    }
                    
                    if totals[expense.month] != nil {
                        if let currentMonSpent = totals[expense.month] as Float? {
                            let newMonSpent = currentMonSpent - expense.billAmount
                            self.expensesRef.child("categories/\(expense.category)/\(expense.month)").setValue(newMonSpent)
                        }
                    }
                    
                    if totals[expense.week] != nil {
                        if let currentMonSpent = totals[expense.week] as Float? {
                            let newMonSpent = currentMonSpent - expense.billAmount
                            self.expensesRef.child("categories/\(expense.category)/\(expense.week)").setValue(newMonSpent)
                        }
                    }
                    
                }
            }
        })
    }
    
    
    
    func deleteGroupExpense(groupExpense: GroupExpense) {
        print("deleting group expense")
    }
}
