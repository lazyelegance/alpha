//
//  CategoryViewController.swift
//  alpha
//
//  Created by Ezra Bathini on 27/07/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import Material

private struct Category {
    var text: String
    var detail: String
    var image: UIImage?
}

class CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    private let tableView: UITableView = UITableView()
    
    private var categories: Array<Category> = Array<Category>()
    
    var tableViewY: CGFloat = 0
    
    var newExpense = Expense()
    var newGroupExpense = GroupExpense()
    var currentStep = AddExpenseStep.category
    var expenseType: ExpenseType = .user
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewY = titleLabel.frame.origin.y + titleLabel.frame.size.height + 5
        
        prepareView()
        prepareItems()
        prepareTableView()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func prepareView() {
        view.backgroundColor = MaterialColor.indigo.accent1
    }
    

    
    private func prepareItems() {
        categories.append(Category(text: "Food", detail: ".", image: UIImage(named: "ic_restaurant_white")))
        categories.append(Category(text: "Rent", detail: "?", image: UIImage(named: "ic_home_white")))
        categories.append(Category(text: "Entertainment", detail: ".", image: UIImage(named: "ic_local_activity_white")))
        categories.append(Category(text: "Groceries", detail: "?", image: UIImage(named: "ic_local_grocery_store_white")))
        categories.append(Category(text: "Fuel", detail: "?", image: UIImage(named: "ic_local_gas_station_white")))
        categories.append(Category(text: "Subscription", detail: "?", image: UIImage(named: "ic_subscriptions_white")))
        
    }
    
    private func prepareTableView() {
        tableView.backgroundColor = MaterialColor.clear
        tableView.separatorStyle = .None
        tableView.registerClass(MaterialTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = CGRectMake(10, tableViewY, self.view.frame.size.width - 20, 350)
        
        self.view.addSubview(tableView)
    }
    

    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count;
    }
    
    /// Returns the number of sections.
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    /// Prepares the cells within the tableView.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: MaterialTableViewCell = MaterialTableViewCell(style: .Subtitle, reuseIdentifier: "Cell")
        
        let item: Category = categories[indexPath.row]
        cell.selectionStyle = .None
        cell.textLabel!.text = item.text
        cell.textLabel!.font = RobotoFont.regular
        cell.textLabel?.textColor = MaterialColor.white
        cell.imageView!.image = item.image?.resize(toWidth: 40)
        cell.imageView!.layer.cornerRadius = 20
        cell.backgroundColor = MaterialColor.indigo.accent1
        cell.contentView.backgroundColor = MaterialColor.clear
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
        if let category = (categories[indexPath.row]).text as String? {
            switch expenseType {
            case .user:
                if let finishVC = self.storyboard?.instantiateViewControllerWithIdentifier("finishViewController") as? FinishViewController {
                    newExpense.category = category
                    finishVC.newExpense = newExpense
                    self.navigationController?.pushViewController(finishVC, animated: true)
                }
                
            case .group:
                if let parityViewController = self.storyboard?.instantiateViewControllerWithIdentifier("parityViewController") as? ParityViewController {
                    newExpense.category = category
                    parityViewController.newGroupExpense = newGroupExpense
//                    ParityViewController.expenseType = .group //Defaulting to group for now
                    self.navigationController?.pushViewController(parityViewController, animated: true)
                }
            }
            
            
        }
        
        
    }
}




