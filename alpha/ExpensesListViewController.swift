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

class ExpensesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIScrollViewDelegate {
    
    var expenseType = ExpenseType.user
    
    var expenses = [Expense]()
    var filteredExpenses = [Expense]()
    var expensesRef = FIRDatabaseReference()
    
    var groupExpenses = [GroupExpense]()
    var fileteredGroupExpenses = [GroupExpense]()
    var groupExpensesRef = FIRDatabaseReference()
    
    var groupName = String()
    var userName = String()
    

    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var headerView: MaterialView!
    @IBOutlet weak var categoryView: MaterialView!
    @IBOutlet weak var monthsView: MaterialView!

    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var categoryViewHeight: NSLayoutConstraint!
    @IBOutlet weak var monthsViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var categoriesTableView: UITableView!
    @IBOutlet weak var monthsTableView: UITableView!

    
    var showFilteredResults = false
    var searchExpanded = false
    var searchShouldExpand = false
    var categoryViewExpanded = false
    var monthsViewExpanded = false
    var showMoreCategoriesText = "Show More"
    var showMoreMonthsText = "Show More"
    
    private var searchBar: SearchBar!

    
    @IBAction func searchButtonClicked(sender: AnyObject) {
        toggleSearchOptions()
    }
    
    
    var categories = ["Food", "Fuel", "Rent"]
    var categoriesDisplayed = [String]()
    var months = ["July 2016", "June 2016"]
    
    let searchBarBackButton: IconButton = IconButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareview()
        preparetableview()
        getExpenses()
        prepareHeaderView()
        prepareSearchOptions()

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
        categoryViewHeight.constant = 0
        monthsViewHeight.constant = 0
    }
    
    private func preparetableview() {
        
        
        tableView.backgroundColor = MaterialColor.clear
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
    }
    
    private func prepareSearchOptions() {
        if categories.count > 3 {
            
        }
    }
    

    private func prepareHeaderView() {
        
        headerViewHeight.constant = 40
        
        searchBar = SearchBar()
        
        searchBar.frame.size = CGSizeMake(self.headerView.width , headerViewHeight.constant)
        
        self.headerView.addSubview(searchBar)
        
        var image: UIImage? = MaterialIcon.cm.clear
        
        // Back button.
        searchBarBackButton.tintColor = MaterialColor.blueGrey.darken4
        searchBarBackButton.setImage(image, forState: .Normal)
        searchBarBackButton.setImage(image, forState: .Highlighted)
        //searchBarBackButton.setTitle("CLEAR", forState: .Normal)
        
        searchBarBackButton.alpha = 0
        searchBarBackButton.addTarget(self, action: #selector(self.handleBackButton), forControlEvents: .TouchUpInside)
        // More button.
        image = MaterialIcon.cm.moreHorizontal
        let moreButton: IconButton = IconButton()
        moreButton.tintColor = MaterialColor.blueGrey.darken4
        moreButton.setImage(image, forState: .Normal)
        moreButton.setImage(image, forState: .Highlighted)
        
        
        
        searchBar.textField.delegate = self
        searchBar.textField.returnKeyType = .Search
        searchBar.textField.keyboardAppearance = .Light
        
        searchBar.clearButtonAutoHandleEnabled = false
        searchBar.clearButton.addTarget(self, action: #selector(self.handleClearButton), forControlEvents: .TouchUpInside)
        
        
        searchBar.rightControls = [searchBarBackButton]
//        searchBar.rightControls = [moreButton]
        
        
    }
    
    private func getExpenses() {
        
        self.expenses.removeAll()
        switch self.expenseType {
        case .user:
            expensesRef.observeEventType(.Value, withBlock: { (expSnapshot) in
                if expSnapshot.exists() {
                    self.expenses = Expense.expensesFromResults(expSnapshot.value! as! NSDictionary, ref: expSnapshot.ref)
                    self.tableView.reloadData()
                    self.categories = Expense.categoryNamesFromResults(expSnapshot.value! as! NSDictionary)
                    self.categoriesTableView.reloadData()
                    self.months = Expense.monthsFromResults(expSnapshot.value! as! NSDictionary)
                    self.monthsTableView.reloadData()
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
        
        toggleSearchOptions()
        showFilteredResults = true
        
        tableView.reloadData()
    }
    
    func filterExpensesByCategory(category: String) {
        switch expenseType {
        case .user:
            filteredExpenses = expenses.filter({ (expense) -> Bool in
                return (expense.category == category)
            })
            toggleSearchOptions()
            showFilteredResults = true
            searchBar.textField.text = category
            searchBarBackButton.alpha = 1
            tableView.reloadData()
        default:
            break //for now
        }
    }
    
    func filterExpensesByMonth(month: String) {
        switch expenseType {
        case .user:
            filteredExpenses = expenses.filter({ (expense) -> Bool in
                if let expenseMonth = expense.month as String? {
                    let expenseMonthStripped = expenseMonth.stringByReplacingOccurrencesOfString("m_", withString: "").stringByReplacingOccurrencesOfString("_", withString: " ")
                    return (month == expenseMonthStripped)
                } else {
                    return false
                }
            })
            toggleSearchOptions()
            showFilteredResults = true
            searchBar.textField.text = month
            searchBarBackButton.alpha = 1
            tableView.reloadData()
        default:
            break //for now
        }
    }

 


    
    
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.searchBar.textField.resignFirstResponder()
    }
    
    
    // MARK: - TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch expenseType {
        case .user:
            switch tableView.tag {
            case 11:
                if categories.count > 3 {
                    if categories.count == 4 {
                        if categoryViewExpanded {
                            return 5
                        } else {
                            return 4
                        }
                    } else {
                        if categoryViewExpanded {
                            return 6
                        } else {
                            return 4
                        }
                    }
                } else {
                    return categories.count
                }
                
            case 22:
                if months.count > 3 {
                    if months.count == 4 {
                        if monthsViewExpanded {
                            return 5
                        } else {
                            return 4
                        }
                    } else {
                        if monthsViewExpanded {
                            return 6
                        } else {
                            return 4
                        }
                    }
                } else {
                    return months.count
                }
            case 33:
                if showFilteredResults {
                    return filteredExpenses.count
                } else {
                    return expenses.count
                }
                
            default:
                return 0
            }
            
        case .group:
            switch tableView.tag {
            case 11:
                return categories.count + 1
            case 22:
                return months.count
            case 33:
                
                return groupExpenses.count
            default:
                return 0
            }
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
            let searchCategoryCell: MaterialTableViewCell = MaterialTableViewCell(style: .Default, reuseIdentifier: "searchCategoryCell")
            
            
            searchCategoryCell.selectionStyle = .None
            searchCategoryCell.textLabel!.font = RobotoFont.mediumWithSize(10)
            
            if tableView.tag == 11 {
                
                if categories.count > 3 {
                    if categories.count == 4 {
                        if categoryViewExpanded {
                            if indexPath.row == 4 {
                                searchCategoryCell.textLabel?.text = showMoreCategoriesText
                                searchCategoryCell.textLabel?.textColor = MaterialColor.indigo.darken1
                            } else {
                                let category = categories[indexPath.row]
                                searchCategoryCell.textLabel?.text = category
                                
                            }
                            return searchCategoryCell
                        } else {
                            if indexPath.row == 3 {
                                searchCategoryCell.textLabel?.text = showMoreCategoriesText
                                searchCategoryCell.textLabel?.textColor = MaterialColor.indigo.darken1
                            } else {
                                let category = categories[indexPath.row]
                                searchCategoryCell.textLabel?.text = category
                                
                            }
                            return searchCategoryCell
                        }
                    } else {
                        if categoryViewExpanded {
                            if indexPath.row == 5 {
                                searchCategoryCell.textLabel?.text = showMoreCategoriesText
                                searchCategoryCell.textLabel?.textColor = MaterialColor.indigo.darken1
                            } else {
                                let category = categories[indexPath.row]
                                searchCategoryCell.textLabel?.text = category
                                
                            }
                            return searchCategoryCell
                        } else {
                            if indexPath.row == 3 {
                                searchCategoryCell.textLabel?.text = showMoreCategoriesText
                                searchCategoryCell.textLabel?.textColor = MaterialColor.indigo.darken1
                            } else {
                                let category = categories[indexPath.row]
                                searchCategoryCell.textLabel?.text = category
                                
                            }
                            return searchCategoryCell
                        }
                    }
                } else {
                    let category = categories[indexPath.row]
                    searchCategoryCell.textLabel?.text = category
                    return searchCategoryCell
                }

                

                
            }
            
            if tableView.tag == 22 {
                if months.count > 3 {
                    if months.count == 4 {
                        if monthsViewExpanded {
                            if indexPath.row == 4 {
                                searchCategoryCell.textLabel?.text = showMoreMonthsText
                                searchCategoryCell.textLabel?.textColor = MaterialColor.indigo.darken1
                            } else {
                                let month = months[indexPath.row]
                                searchCategoryCell.textLabel?.text = month
                                
                            }
                            return searchCategoryCell
                        } else {
                            if indexPath.row == 3 {
                                searchCategoryCell.textLabel?.text = showMoreMonthsText
                                searchCategoryCell.textLabel?.textColor = MaterialColor.indigo.darken1
                            } else {
                                let month = months[indexPath.row]
                                searchCategoryCell.textLabel?.text = month
                                
                            }
                            return searchCategoryCell
                        }
                    } else {
                        if monthsViewExpanded {
                            if indexPath.row == 5 {
                                searchCategoryCell.textLabel?.text = showMoreMonthsText
                                searchCategoryCell.textLabel?.textColor = MaterialColor.indigo.darken1
                            } else {
                                let month = months[indexPath.row]
                                searchCategoryCell.textLabel?.text = month
                                
                            }
                            return searchCategoryCell
                        } else {
                            if indexPath.row == 3 {
                                searchCategoryCell.textLabel?.text = showMoreMonthsText
                                searchCategoryCell.textLabel?.textColor = MaterialColor.indigo.darken1
                            } else {
                                let month = months[indexPath.row]
                                searchCategoryCell.textLabel?.text = month
                                
                            }
                            return searchCategoryCell
                        }
                    }
                } else {
                    let month = months[indexPath.row]
                    searchCategoryCell.textLabel?.text = month
                    return searchCategoryCell
                }
            }
            
            
            
            let expenseCell = tableView.dequeueReusableCellWithIdentifier("expenseCell", forIndexPath: indexPath) as! ExpenseCell
            expenseCell.backgroundColor = MaterialColor.amber.lighten1
            if indexPath.row % 2 == 1 {
                expenseCell.backgroundColor = MaterialColor.amber.lighten2
            }
            if showFilteredResults {
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
            if showFilteredResults {
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
        if tableView.tag == 33 {
            return 80
        } else {
            return 30
        }
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
                
                if self.showFilteredResults {
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
                if self.showFilteredResults {
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
    

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("................................")
        if tableView.tag == 11 {
            self.searchBar.textField.resignFirstResponder()
            let cellsCount = tableView.numberOfRowsInSection(0)
            if cellsCount >= 4 && indexPath.row == cellsCount - 1 {
                toggleCategoryView()
            } else {
                self.filterExpensesByCategory(categories[indexPath.row])
            }
        } else if tableView.tag == 22 {
            self.searchBar.textField.resignFirstResponder()
            let cellsCount = tableView.numberOfRowsInSection(0)
            if cellsCount >= 4 && indexPath.row == cellsCount - 1 {
                toggleMonthsView()
            } else {
                self.filterExpensesByMonth(months[indexPath.row])
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
    
    // MARK: - TOGGLE
    
    func toggleCategoryView()  {
        if !self.categoryViewExpanded {
            self.categoryViewHeight.constant = 180
            self.showMoreCategoriesText = "Show Less"
        } else {
            self.categoryViewHeight.constant = 120
            self.showMoreCategoriesText = "Show More"
        }
        self.categoryViewExpanded = !self.categoryViewExpanded
        
        if self.monthsViewExpanded {
            self.monthsViewHeight.constant = 120
            self.showMoreMonthsText = "Show More"
            self.monthsViewExpanded = !self.monthsViewExpanded
        }
        
        UIView.animateWithDuration(0.5, animations: {
            self.view.layoutIfNeeded()
        })
        
        categoriesTableView.reloadData()
        monthsTableView.reloadData()
        
    }
    
    func toggleMonthsView() {
        if !self.monthsViewExpanded {
            self.monthsViewHeight.constant = 180
            self.showMoreMonthsText = "Show Less"
            
        } else {
            self.monthsViewHeight.constant = 120
            self.showMoreMonthsText = "Show More"
        }
        self.monthsViewExpanded = !self.monthsViewExpanded
        
        if self.categoryViewExpanded {
            self.categoryViewHeight.constant = 120
            self.showMoreCategoriesText = "Show More"
            self.categoryViewExpanded = !self.categoryViewExpanded
        }
        UIView.animateWithDuration(0.5, animations: {
            self.view.layoutIfNeeded()
        })
        categoriesTableView.reloadData()
        monthsTableView.reloadData()
    }
    
    func toggleSearchOptions() {
        if !self.searchExpanded {
            
            self.categoryViewHeight.constant = 120
            self.monthsViewHeight.constant = 120
        } else {
            categoryViewHeight.constant = 0
            monthsViewHeight.constant = 0
        }
        
        UIView.animateWithDuration(0.5, animations: {
            self.view.layoutIfNeeded()
        })
        self.searchExpanded = !self.searchExpanded

    }
    
    
    
    
    
    
    
    func handleClearButton() {
        searchBarBackButton.alpha = 0
        self.searchBar.textField.text = nil
        self.searchBar.textField.resignFirstResponder()
        self.toggleSearchOptions()
    }
    
    func handleBackButton() {
        searchBarBackButton.alpha = 0
        self.searchBar.textField.text = nil
        self.searchBar.textField.resignFirstResponder()
//        self.toggleSearchOptions()
        showFilteredResults = false
        tableView.reloadData()
    }
    
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if !searchExpanded {
            toggleSearchOptions()
        }
        
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        print("end")
    }
    
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        //resignFirstResponder()
        print("end")
        print(textField.text)
        
        if let textFieldText = textField.text as String? {
            
            if let searchText = textFieldText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as String? {
                if searchText != "" {
                    filterContentForSearchText(searchText)
                    searchBarBackButton.alpha = 1
                }
            }
        }
        
        return true
    }
}
