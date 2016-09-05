//
//  CategoryViewController.swift
//  alpha
//
//  Created by Ezra Bathini on 27/07/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import Material



class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!

    
    var categories = [Category]()
    
    
    
    var newExpense = Expense()
    var newGroupExpense = GroupExpense()
    var currentStep = AddExpenseStep.category
    var expenseType: ExpenseType = .user
    
    @IBOutlet weak var backButton: FabButton!
    
    
    let addNewText = "+ Add New"
    let categoryFont = RobotoFont.mediumWithSize(10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareView()
        prepareItems()
        


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func prepareView() {
        view.backgroundColor = MaterialColor.indigo.accent1
        backButton.setImage(MaterialIcon.arrowBack, forState: .Normal)
        tableView.backgroundColor = MaterialColor.clear
    }
    

    
    private func prepareItems() {
        
                
        tableView.reloadData()
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("categoryCell", forIndexPath: indexPath) as! CategoryCell
        cell.backgroundColor = MaterialColor.clear
        cell.contentView.backgroundColor = MaterialColor.clear
        
        cell.categoryLabel.font = categoryFont
        cell.categoryLabel.textColor = MaterialColor.white
        if indexPath.row == categories.count {
            cell.categoryLabel.text = addNewText
            return cell
        }
        let category = categories[indexPath.row]
        cell.categoryLabel.text = category.name.uppercaseString
        return cell
        
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count + 1
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row != categories.count {
            if let category = (categories[indexPath.row]).name as String? {
                switch expenseType {
                case .user:
                    if let finishVC = self.storyboard?.instantiateViewControllerWithIdentifier("finishViewController") as? FinishViewController {
                        newExpense.category = category
                        finishVC.newExpense = newExpense
                        self.navigationController?.pushViewController(finishVC, animated: true)
                    }
                    
                case .group:
                    if let parityViewController = self.storyboard?.instantiateViewControllerWithIdentifier("parityViewController") as? ParityViewController {
                        newGroupExpense.category = category
                        parityViewController.newGroupExpense = newGroupExpense
                        //                    ParityViewController.expenseType = .group //Defaulting to group for now
                        self.navigationController?.pushViewController(parityViewController, animated: true)
                    }
                }
            }
        } else {
            
            if let addExpenseVC = self.storyboard?.instantiateViewControllerWithIdentifier("addExpenseController") as? AddExpenseController {
                
                addExpenseVC.currentStep = .category
                addExpenseVC.expenseType = self.expenseType
                switch expenseType {
                case .user:
                    addExpenseVC.newExpense = self.newExpense
                case .group:
                    addExpenseVC.newGroupExpense = self.newGroupExpense
                }
                self.navigationController?.pushViewController(addExpenseVC, animated: true)
            }
            print("to new add")
        }
    }
    
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("categoryCell", forIndexPath: indexPath) as! AlphaCollectionCell
        cell.backgroundColor = MaterialColor.clear
        
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 2

        cell.categoryButton.titleLabel?.font = categoryFont
        
        if indexPath.row == categories.count {

            
            cell.categoryButton.setTitle(addNewText.uppercaseString, forState: .Normal)
            
            return cell
        }
        
        let category = categories[indexPath.row]

        cell.categoryButton.setTitle(category.name.uppercaseString, forState: .Normal)
        
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if indexPath.row == categories.count {
            let categorySize = (addNewText.uppercaseString as NSString).sizeWithAttributes([NSFontAttributeName: categoryFont])
            return CGSizeMake(categorySize.width + 40, 30)
        } else {
            let category = categories[indexPath.row]
            let categorySize = (category.name.uppercaseString as NSString).sizeWithAttributes([NSFontAttributeName: categoryFont])
            return CGSizeMake(categorySize.width + 40, 30)
        }
        
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row != categories.count {
            if let category = (categories[indexPath.row]).name as String? {
                switch expenseType {
                case .user:
                    if let finishVC = self.storyboard?.instantiateViewControllerWithIdentifier("finishViewController") as? FinishViewController {
                        newExpense.category = category
                        finishVC.newExpense = newExpense
                        self.navigationController?.pushViewController(finishVC, animated: true)
                    }
                    
                case .group:
                    if let parityViewController = self.storyboard?.instantiateViewControllerWithIdentifier("parityViewController") as? ParityViewController {
                        newGroupExpense.category = category
                        parityViewController.newGroupExpense = newGroupExpense
                        //                    ParityViewController.expenseType = .group //Defaulting to group for now
                        self.navigationController?.pushViewController(parityViewController, animated: true)
                    }
                }
            }
        } else {
            
            if let addExpenseVC = self.storyboard?.instantiateViewControllerWithIdentifier("addExpenseController") as? AddExpenseController {
                
                addExpenseVC.currentStep = .category
                addExpenseVC.expenseType = self.expenseType
                switch expenseType {
                case .user:
                    addExpenseVC.newExpense = self.newExpense
                case .group:
                    addExpenseVC.newGroupExpense = self.newGroupExpense
                }
                self.navigationController?.pushViewController(addExpenseVC, animated: true)
            }
            print("to new add")
        }

    }
    
    @IBAction func backOneStep(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func getMaxCellWidth() -> CGFloat {
        
        var categoryWidths = [CGFloat]()
        
        for category in self.categories {
            let cellSize = (category.name.uppercaseString as NSString).sizeWithAttributes([NSFontAttributeName: categoryFont])
            categoryWidths.append(cellSize.width)
        }
        let cellSize = (addNewText.uppercaseString as NSString).sizeWithAttributes([NSFontAttributeName: categoryFont])
        categoryWidths.append(cellSize.width)
        
        if categoryWidths.maxElement() != nil {
            return categoryWidths.maxElement()! + 10
        } else {
            return 80
        }
    }
    
    
}




