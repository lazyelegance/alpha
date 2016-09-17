//
//  ExpensesListViewController.swift
//  alpha
//
//  Created by Ezra Bathini on 30/07/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ExpensesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var expenseType = ExpenseType.user
    
    var expenses = [Expense]()
    var filteredExpenses = [Expense]()
    var expensesRef = FIRDatabaseReference()
    
    var groupExpenses = [GroupExpense]()
    var fileteredGroupExpenses = [GroupExpense]()
    var groupExpensesRef = FIRDatabaseReference()
    
    var groupName = String()
    var userName = String()
    

    
    
    @IBOutlet weak var sCCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var headerView: MaterialView!
    @IBOutlet weak var categoryView: MaterialView!
    @IBOutlet weak var monthsView: MaterialView!

    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var categoryViewHeight: NSLayoutConstraint!
    @IBOutlet weak var monthsViewHeight: NSLayoutConstraint!
    


    var selectedCategory = String()
    var showFilteredResults = false
    var searchExpanded = false
    var searchShouldExpand = false
    var categoryViewExpanded = false
    var monthsViewExpanded = false
    var showMoreCategoriesText = "Show More"
    var showMoreMonthsText = "Show More"
    
    //fileprivate var searchBar: SearchBar!

    
    @IBAction func searchButtonClicked(_ sender: AnyObject) {
        toggleSearchOptions()
    }
    
    var categoryCounts = [String: Int]()
    
    var categories = [Category]()
    
    var categoriesDisplayed = [String]()
    var months = ["July 2016", "June 2016"]
    
    let searchBarBackButton: IconButton = IconButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareview()
        preparetableview()
        getExpenses()
        prepareHeaderView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func prepareview() {
        view.backgroundColor = MaterialColor.amber.base
        if expenseType == .group {
            view.backgroundColor = MaterialColor.teal.base
        }
        categoryViewHeight.constant = 0
        monthsViewHeight.constant = 0
    }
    
    fileprivate func preparetableview() {
        
        
        tableView.backgroundColor = MaterialColor.clear
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        sCCollectionView.backgroundColor = MaterialColor.clear
    }
    
    fileprivate func preparetableviewdata() {
        
        if showFilteredResults {
            filterExpensesByCategory(selectedCategory)
        }
        
        self.tableView.reloadData()
        
        
    }
    
    
    

    

    fileprivate func prepareHeaderView() {
        
        headerViewHeight.constant = 40
        
//        searchBar = SearchBar()
//        
//        searchBar.frame.size = CGSize(width: self.headerView.width , height: headerViewHeight.constant)
//        searchBar.layer.masksToBounds = true
//        
//        self.headerView.addSubview(searchBar)
        
        
        headerView.layer.masksToBounds = true
        
        var image: UIImage? = MaterialIcon.cm.clear
        
        // Back button.
//        searchBarBackButton.tintColor = MaterialColor.blueGrey.darken4
//        searchBarBackButton.setImage(image, forState: .Normal)
//        searchBarBackButton.setImage(image, forState: .Highlighted)
//        
//        
//        searchBarBackButton.alpha = 0
//        searchBarBackButton.addTarget(self, action: #selector(self.handleBackButton), forControlEvents: .TouchUpInside)
//        
//        image = MaterialIcon.cm.moreHorizontal
//        let moreButton: IconButton = IconButton()
//        moreButton.tintColor = MaterialColor.blueGrey.darken4
//        moreButton.setImage(image, forState: .Normal)
//        moreButton.setImage(image, forState: .Highlighted)
//        
//        
//        
//        searchBar.textField.delegate = self
//        searchBar.textField.returnKeyType = .Search
//        searchBar.textField.keyboardAppearance = .Light
//        
//        searchBar.clearButtonAutoHandleEnabled = false
//        searchBar.clearButton.addTarget(self, action: #selector(self.handleClearButton), forControlEvents: .TouchUpInside)
//        
//        
//        searchBar.rightControls = [searchBarBackButton]
//        searchBar.rightControls = [moreButton]
        
        
    }
    
    fileprivate func getExpenses() {
        
        self.expenses.removeAll()
        switch self.expenseType {
        case .user:
            expensesRef.observe(.value, with: { (expSnapshot) in
                if expSnapshot.exists() {
                    self.expenses = Expense.expensesFromResults(expSnapshot.value! as! NSDictionary, ref: expSnapshot.ref)
                    self.preparetableviewdata()
                    //TO UPDATE
                    self.months = Expense.monthsFromResults(expSnapshot.value! as! NSDictionary)
//                    self.monthsTableView.reloadData()
                }
                
            })
        case .group:
            print(groupExpensesRef)
             groupExpensesRef.observe(.value, with: { (grpExpSnapshot) in
                if grpExpSnapshot.exists() {
                    self.groupExpenses = GroupExpense.expensesFromFirebase(grpExpSnapshot.value! as! NSDictionary, firebasereference: grpExpSnapshot.ref)
                    self.tableView.reloadData()
                }
                
             })
        }
        
    }

    
    // MARK: - Search
    
    func updateSearchResultsForSearchController(_ searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        print(searchText)
        switch expenseType {
        case .user:
            print("user")
            filteredExpenses = expenses.filter { expense in
                return expense.description.lowercased().contains(searchText.lowercased())
            }
        case .group:
            fileteredGroupExpenses = groupExpenses.filter { expense in
                return expense.description.lowercased().contains(searchText.lowercased())
            }
        }
        
        toggleSearchOptions()
        showFilteredResults = true
        
        tableView.reloadData()
    }
    
    func filterExpensesByCategory(_ category: String) {
        switch expenseType {
        case .user:
            filteredExpenses = expenses.filter({ (expense) -> Bool in
                return (expense.category == category)
            })
            showFilteredResults = true
//            searchBar.textField.text = category
            searchBarBackButton.alpha = 1
            tableView.reloadData()
        default:
            break //for now
        }
    }
    
    func filterExpensesByMonth(_ month: String) {
        switch expenseType {
        case .user:
            filteredExpenses = expenses.filter({ (expense) -> Bool in
                if let expenseMonth = expense.month as String? {
                    let expenseMonthStripped = expenseMonth.replacingOccurrences(of: "m_", with: "").replacingOccurrences(of: "_", with: " ")
                    return (month == expenseMonthStripped)
                } else {
                    return false
                }
            })
            toggleSearchOptions()
            showFilteredResults = true
//            searchBar.textField.text = month
            searchBarBackButton.alpha = 1
            tableView.reloadData()
        default:
            break //for now
        }
    }

 


    
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.searchBar.textField.resignFirstResponder()
    }
    
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch expenseType {
        case .user:
            if showFilteredResults {
                return filteredExpenses.count
            } else {
                return expenses.count
            }
        case .group:
            return groupExpenses.count
        }

    }
    
    /// Returns the number of sections.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// Prepares the cells within the tableView.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell: MaterialTableViewCell = MaterialTableViewCell(style: .subtitle, reuseIdentifier: "expenseCell")
        
        switch expenseType {
        case .user:
            let expenseCell = tableView.dequeueReusableCell(withIdentifier: "expenseCell", for: indexPath) as! ExpenseCell
            expenseCell.backgroundColor = MaterialColor.amber.lighten1
            if (indexPath as NSIndexPath).row % 2 == 1 {
                expenseCell.backgroundColor = MaterialColor.amber.lighten2
            }
            if showFilteredResults {
                if let expense = filteredExpenses[(indexPath as NSIndexPath).row] as Expense? {
                    expenseCell.expense = expense
                    return expenseCell
                }
            } else {
                if let expense = expenses[(indexPath as NSIndexPath).row] as Expense? {
                    expenseCell.expense = expense
                    return expenseCell
                }
            }
            
        case .group:
            
            let groupExpenseCell = tableView.dequeueReusableCell(withIdentifier: "groupExpenseCell", for: indexPath) as! GroupExpenseCell
            groupExpenseCell.backgroundColor = MaterialColor.teal.lighten1
            if (indexPath as NSIndexPath).row % 2 == 1 {
                groupExpenseCell.backgroundColor = MaterialColor.teal.lighten2
            }
            if showFilteredResults {
                if let groupExpense = fileteredGroupExpenses[(indexPath as NSIndexPath).row] as GroupExpense? {
                    groupExpenseCell.groupExpense = groupExpense
                    return groupExpenseCell
                }
            } else {
                if let groupExpense = groupExpenses[(indexPath as NSIndexPath).row] as GroupExpense? {
                    groupExpenseCell.groupExpense = groupExpense
                    return groupExpenseCell
                }
            }
        }
 
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if expenseType == .group {
            if let grpExpCell = tableView.cellForRow(at: indexPath) as? GroupExpenseCell {
                if grpExpCell.groupExpense?.addedBy != FIRAuth.auth()?.currentUser?.uid {
                    return false
                }
            }
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let edit = UITableViewRowAction(style: .default, title: "Edit") { (action, index) in
            print("edit")
        }
        
        edit.backgroundColor = MaterialColor.blue.accent3
        
        
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, index) in
            print("delete")
            switch self.expenseType {
            case .user:
                
                if self.showFilteredResults {
                    if let expense = self.filteredExpenses[(index as NSIndexPath).row] as Expense? {
                        self.deleteUserExpense(expense)
                        self.filteredExpenses.remove(at: (index as NSIndexPath).row)
                        self.tableView.reloadData()
                    }
                } else {
                    if let expense = self.expenses[(index as NSIndexPath).row] as Expense? {
                        self.deleteUserExpense(expense)
                    }
                }
                
                
            case .group:
                if self.showFilteredResults {
                    if let groupExpense = self.fileteredGroupExpenses[(index as NSIndexPath).row] as GroupExpense? {
                        self.deleteGroupExpense(groupExpense)
                        self.fileteredGroupExpenses.remove(at: (index as NSIndexPath).row)
                        self.tableView.reloadData()
                    }
                } else {
                    if let groupExpense = self.groupExpenses[(index as NSIndexPath).row] as GroupExpense? {
                        self.deleteGroupExpense(groupExpense)
                    }
                }
            }
        }
        
        return  [delete, edit]
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    

    // MARK : COLLECTION VIEW
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCategoryCell", for: indexPath) as! AlphaCollectionCell
        cell.backgroundColor = MaterialColor.clear
        
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 2
        
        cell.nameLabel.font = categoryFont
        
        let category = categories[(indexPath as NSIndexPath).row]
        print(category)
        cell.nameLabel.textColor = MaterialColor.black
        cell.nameLabel.text = category.name.uppercased()
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let category = categories[(indexPath as NSIndexPath).row]
        let categorySize = (category.name.uppercased() as NSString).size(attributes: [NSFontAttributeName: categoryFont])
        return CGSize(width: categorySize.width + 20, height: 30)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let category = (categories[(indexPath as NSIndexPath).row]).name as String? {
            filterExpensesByCategory(category)
        }
        
    }
    
    
    
    // MARK: - DELETE EXPENSE
    
    func deleteUserExpense(_ expense: Expense) {
        expensesRef.child(expense.expenseId).removeValue { (error, ref) in
            if error != nil {
                print(error?.localizedDescription)
            }
        }

        expensesRef.child("totals").observeSingleEvent(of: .value, with: { (snapshot) in
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
        
        expensesRef.child("categories/\(expense.category)").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                print(snapshot)
                print("categories/\(expense.category)/\(expense.month)")
                if let totals = Expense.categoryFromResults(snapshot.value! as! NSDictionary) as [String: AnyObject]? {
                    
                    if let currentTotalSpent = totals["total"] as? Float {
                        let newTotalSpent = currentTotalSpent - expense.billAmount
                        self.expensesRef.child("categories/\(expense.category)/total").setValue(newTotalSpent)
                    }
                    
                    if totals[expense.month] != nil {
                        if let currentMonSpent = totals[expense.month] as? Float {
                            let newMonSpent = currentMonSpent - expense.billAmount
                            self.expensesRef.child("categories/\(expense.category)/\(expense.month)").setValue(newMonSpent)
                        }
                    }
                    
                    if totals[expense.week] != nil {
                        if let currentMonSpent = totals[expense.week] as? Float {
                            let newMonSpent = currentMonSpent - expense.billAmount
                            self.expensesRef.child("categories/\(expense.category)/\(expense.week)").setValue(newMonSpent)
                        }
                    }
                    
                    if totals["counter"] != nil {
                        if let currentCounter = totals["counter"] as? Int {
                            self.expensesRef.child("categories/\(expense.category)/counter").setValue(currentCounter - 1)
                        }
                    }
                    
                    if totals["counter_\(expense.month)"] != nil {
                        if let currentCounter = totals["counter_\(expense.month)"] as? Int {
                            self.expensesRef.child("categories/\(expense.category)/counter_\(expense.month)").setValue(currentCounter - 1)
                        }
                    }
                    
                    if totals["counter_\(expense.week)"] != nil {
                        if let currentCounter = totals["counter_\(expense.week)"] as? Int {
                            self.expensesRef.child("categories/\(expense.category)/counter_\(expense.week)").setValue(currentCounter - 1)
                        }
                    }
                    
                    
                    
                }
            }
        })
    }
    
    func deleteGroupExpense(_ groupExpense: GroupExpense) {
        // TODO
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
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
        

        
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
            self.categoryViewHeight.constant = 40
            self.showMoreCategoriesText = "Show More"
            self.categoryViewExpanded = !self.categoryViewExpanded
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })

    }
    
    func toggleSearchOptions() {
        if !self.searchExpanded {
            
            self.categoryViewHeight.constant = 40
            self.monthsViewHeight.constant = 120
        } else {
            categoryViewHeight.constant = 0
            monthsViewHeight.constant = 0
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
        self.searchExpanded = !self.searchExpanded

    }
    
    
    
    
    
    
    
//    func handleClearButton() {
//        searchBarBackButton.alpha = 0
//        self.searchBar.textField.text = nil
//        self.searchBar.textField.resignFirstResponder()
//        self.toggleSearchOptions()
//    }
//    
//    func handleBackButton() {
//        searchBarBackButton.alpha = 0
//        self.searchBar.textField.text = nil
//        self.searchBar.textField.resignFirstResponder()
////        self.toggleSearchOptions()
//        showFilteredResults = false
//        tableView.reloadData()
//    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.text = nil
        searchBarBackButton.alpha = 0
        
        if !searchExpanded {
            toggleSearchOptions()
        }
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("end")
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        //resignFirstResponder()
        print("end")
        print(textField.text)
        
        if let textFieldText = textField.text as String? {
            
            if let searchText = textFieldText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) as String? {
                if searchText != "" {
                    filterContentForSearchText(searchText)
                    searchBarBackButton.alpha = 1
                }
            }
        }
        
        return true
    }
}
