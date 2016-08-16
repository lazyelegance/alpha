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
    
    @IBOutlet weak var categoryViewHeight: NSLayoutConstraint!
    @IBOutlet weak var monthsView: MaterialView!
    
    @IBOutlet weak var categoriesTableView: UITableView!
    
    
    
    var categories = ["Food", "Fuel", "Rent"]
    var months = ["July 2016", "June 2016"]
    
    enum dataType {
        case category
        case month
        case moreCategory
        case moreMonth
    }
    
    var tableViewData = [[String : dataType]]()
    
    var expanded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        categoriesTableView.dataSource = self
        categoriesTableView.delegate = self
         prepareDataForTableViews()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

        
        
    }
    
    
    func prepareDataForTableViews() {
        tableViewData.removeAll()
        for category in categories {
            tableViewData.append([category : .category])
        }
        
        tableViewData.append(["+ More": .moreCategory])
        
        for month in categories {
            tableViewData.append([month : .month])
        }
        
        tableViewData.append(["+ More": .moreMonth])
        
        categoriesTableView.reloadData()
    }
    
    
    
    // MARK: - TableVIew
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return tableViewData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let searchCategoryCell: MaterialTableViewCell = MaterialTableViewCell(style: .Default, reuseIdentifier: "searchCategoryCell")
        
        
        searchCategoryCell.selectionStyle = .None
        searchCategoryCell.textLabel!.font = RobotoFont.mediumWithSize(10)
        
        
        
        if let item = tableViewData[indexPath.row] as [String : dataType]? {
            for i in item {
                searchCategoryCell.textLabel!.text = i.0
            }
            
        }
        
        return searchCategoryCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 20
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.tag == 11 {
            if !self.expanded {
                self.categoryViewHeight.constant = 300
                
            } else {
                self.categoryViewHeight.constant = 90
            }
            self.expanded = !self.expanded
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

}
