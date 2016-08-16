//
//  ExpensesSearchViewController.swift
//  alpha
//
//  Created by Ezra Bathini on 16/08/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import Material


class ExpensesSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var headerView: MaterialView!

    @IBOutlet weak var categoryView: MaterialView!
    @IBOutlet weak var monthsView: MaterialView!
    
    @IBOutlet weak var categoryViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var monthsViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var categoriesTableView: UITableView!
    @IBOutlet weak var monthsTableView: UITableView!
    
    
    var categories = ["Food", "Fuel", "Rent"]
    var months = ["July 2016", "June 2016"]

    var expenseType = ExpenseType.user
    
    var expenses = [Expense]()
    var groupExpenses = [GroupExpense]()
    
    
    var categoryViewExpanded = false
    var monthsViewExpanded = false
    var showMoreCategoriesText = "Show More"
    var showMoreMonthsText = "Show More"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        categoriesTableView.dataSource = self
        categoriesTableView.delegate = self
        monthsTableView.dataSource = self
        monthsTableView.delegate = self

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

        
        
    }
    
    

    
    
    // MARK: - TableVIew
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 11 {
            return categories.count + 1
        }
        
        if tableView.tag == 22 {
            return months.count + 1
        }
        
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let searchCategoryCell: MaterialTableViewCell = MaterialTableViewCell(style: .Default, reuseIdentifier: "searchCategoryCell")
        
        
        searchCategoryCell.selectionStyle = .None
        searchCategoryCell.textLabel!.font = RobotoFont.mediumWithSize(10)
        
        if tableView.tag == 11 {
            if indexPath.row == categories.count {
                searchCategoryCell.textLabel?.text = showMoreCategoriesText
                searchCategoryCell.textLabel?.textColor = MaterialColor.indigo.darken1
            } else {
                let category = categories[indexPath.row]
                searchCategoryCell.textLabel?.text = category
                
            }
            return searchCategoryCell
        }
        
        if tableView.tag == 22 {
            if indexPath.row == months.count {
                searchCategoryCell.textLabel?.text = showMoreMonthsText
                searchCategoryCell.textLabel?.textColor = MaterialColor.indigo.darken1
            } else {
                let month = months[indexPath.row]
                searchCategoryCell.textLabel?.text = month
                
            }
            return searchCategoryCell
        }
        
        
        return searchCategoryCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.tag == 11 {
            if indexPath.row == categories.count {
                toggleCategoryView()
            }
            
        } else if tableView.tag == 22 {
            if indexPath.row == months.count {
                toggleMonthsView()
            }
        }
    }
    
    func toggleCategoryView()  {
        if !self.categoryViewExpanded {
            self.categoryViewHeight.constant = 300
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
        categoriesTableView.reloadData()
        monthsTableView.reloadData()
    
    }
    
    func toggleMonthsView() {
        if !self.monthsViewExpanded {
            self.monthsViewHeight.constant = 300
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
        categoriesTableView.reloadData()
        monthsTableView.reloadData()
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
