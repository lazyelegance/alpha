//
//  ExpensesListController.swift
//  alpha
//
//  Created by Ezra Bathini on 19/07/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import Material
import Firebase
import FirebaseDatabase

class ExpensesListController: UITableViewController {
    
    var expenses = [Expense]()
    
    var expensesRef = FIRDatabaseReference()
    
    var expenseType = ExpenseType.user


    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var headerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareview()
        preparetableview()
        getExpenses()
    }
    
//    override func viewWillAppear(animated: Bool) {
//        getExpenses()
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func prepareview() {
        headerLabel.text = "All" + " Expenses"
        headerView.backgroundColor = MaterialColor.teal.lighten1
        headerView.frame.size.height = 90
    }
    
    private func preparetableview() {
        tableView.backgroundColor = MaterialColor.teal.lighten1
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func getExpenses() {
        expensesRef.observeEventType(.Value, withBlock: { (expSnapshot) in
            self.expenses = Expense.expensesFromResults(expSnapshot.value! as! NSDictionary, ref: expSnapshot.ref)
            print("here")
            print(self.expenses)
            self.tableView.reloadData()
        })
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return expenses.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("expensesCell", forIndexPath: indexPath) as! ExpensesCell

        if let expense = expenses[indexPath.row] as Expense? {
            cell.expense = expense
        }

        return cell
    }
    
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
 

}
