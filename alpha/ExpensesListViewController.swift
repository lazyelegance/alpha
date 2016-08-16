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

class ExpensesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ExpenseSearchControllerDelegate {
    
    var expenseType = ExpenseType.user
    
    var expenses = [Expense]()
    var filteredExpenses = [Expense]()
    var expensesRef = FIRDatabaseReference()
    
    var groupExpenses = [GroupExpense]()
    var fileteredGroupExpenses = [GroupExpense]()
    var groupExpensesRef = FIRDatabaseReference()
    
    var groupName = String()
    var userName = String()
    

    @IBOutlet weak var headerDetail: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchController: ExpenseSearchController!
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBAction func searchButtonClicked(sender: AnyObject) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareview()
        preparetableview()
        getExpenses()
        prepareHeaderView()
        prepareSearchController()

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
    
    private func prepareSearchController() {
        
        
        searchController = ExpenseSearchController(searchResultsController: self, searchBarFrame: CGRectMake(0.0, 0.0, tableView.frame.size.width, 50.0), searchBarFont: RobotoFont.mediumWithSize(10), searchBarTextColor: MaterialColor.black, searchBarTintColor: MaterialColor.amber.base)
        searchController.expenseSearchDelete = self
        //searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.expenseSearchBar.sizeToFit()
        tableView.tableHeaderView = searchController.expenseSearchBar
        
        // CGRectGetHeight(searchController.expenseSearchBar.frame))
        
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

    
    // MARK: - Search
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        print(searchText)
        switch expenseType {
        case .user:
            print("user")
            filteredExpenses = expenses.filter { expense in
                return expense.description.lowercaseString.containsString(searchText.lowercaseString)
            }
        case .group:
            fileteredGroupExpenses = groupExpenses.filter { expense in
                return expense.description.lowercaseString.containsString(searchText.lowercaseString)
            }
        }
        
        tableView.reloadData()
    }

 

    func didStartSearching() {
        
    }
    
    func didTapOnSearchButton() {
        
    }
    
    func didTapOnCancelButton() {
        
    }
    
    func didChangeSearchText(searchText: String) {
        filterContentForSearchText(searchText)
    }
    
    
    
    
    
    
    
    // MARK: - TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch expenseType {
        case .user:
            if searchController.expenseSearchBar.text != "" {
                return filteredExpenses.count
            }
            return expenses.count
        case .group:
            if searchController.active && searchController.expenseSearchBar.text != "" {
                return fileteredGroupExpenses.count
            }
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
            expenseCell.backgroundColor = MaterialColor.amber.lighten1
            if indexPath.row % 2 == 1 {
                expenseCell.backgroundColor = MaterialColor.amber.lighten2
            }
            if searchController.expenseSearchBar.text != "" {
                if let expense = filteredExpenses[indexPath.row] as Expense? {
                    expenseCell.expense = expense
                    return expenseCell
                }
            } else {
                if let expense = expenses[indexPath.row] as Expense? {
                    expenseCell.expense = expense
                    return expenseCell
                }
            }
            
        case .group:
            
            let groupExpenseCell = tableView.dequeueReusableCellWithIdentifier("groupExpenseCell", forIndexPath: indexPath) as! GroupExpenseCell
            groupExpenseCell.backgroundColor = MaterialColor.teal.lighten1
            if indexPath.row % 2 == 1 {
                groupExpenseCell.backgroundColor = MaterialColor.teal.lighten2
            }
            if searchController.active && searchController.searchBar.text != "" {
                if let groupExpense = fileteredGroupExpenses[indexPath.row] as GroupExpense? {
                    groupExpenseCell.groupExpense = groupExpense
                    return groupExpenseCell
                }
            } else {
                if let groupExpense = groupExpenses[indexPath.row] as GroupExpense? {
                    groupExpenseCell.groupExpense = groupExpense
                    return groupExpenseCell
                }
            }
        }
 
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if expenseType == .group {
            if let grpExpCell = tableView.cellForRowAtIndexPath(indexPath) as? GroupExpenseCell {
                if grpExpCell.groupExpense?.addedBy != FIRAuth.auth()?.currentUser?.uid {
                    return false
                }
            }
        }
        return true
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let edit = UITableViewRowAction(style: .Default, title: "Edit") { (action, index) in
            print("edit")
        }
        
        edit.backgroundColor = MaterialColor.blue.accent3
        
        
        let delete = UITableViewRowAction(style: .Default, title: "Delete") { (action, index) in
            print("delete")
            switch self.expenseType {
            case .user:
                
                if self.searchController.active && self.searchController.searchBar.text != "" {
                    if let expense = self.filteredExpenses[index.row] as Expense? {
                        self.deleteUserExpense(expense)
                        self.filteredExpenses.removeAtIndex(index.row)
                        self.tableView.reloadData()
                    }
                } else {
                    if let expense = self.expenses[index.row] as Expense? {
                        self.deleteUserExpense(expense)
                    }
                }
                
                
            case .group:
                if self.searchController.active && self.searchController.searchBar.text != "" {
                    if let groupExpense = self.fileteredGroupExpenses[index.row] as GroupExpense? {
                        self.deleteGroupExpense(groupExpense)
                        self.fileteredGroupExpenses.removeAtIndex(index.row)
                        self.tableView.reloadData()
                    }
                } else {
                    if let groupExpense = self.groupExpenses[index.row] as GroupExpense? {
                        self.deleteGroupExpense(groupExpense)
                    }
                }
            }
        }
        
        return  [delete, edit]
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
