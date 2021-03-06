//
//  CategoryViewController.swift
//  alpha
//
//  Created by Ezra Bathini on 27/07/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit




class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!

    
    var categories = [Category]()
    
    var defaultCategories = [Category]()
    
    var newExpense = Expense()
    var newGroupExpense = GroupExpense()
    var currentStep = AddExpenseStep.category
    var expenseType: ExpenseType = .user
    
    @IBOutlet weak var backButton: FabButton!
    
    
    let addNewText = "+ Add New"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareView()
        prepareItems()
        


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func prepareView() {
        view.backgroundColor = MaterialColor.indigo.accent1
        backButton.setImage(MaterialIcon.arrowBack, for: .normal)
        tableView.backgroundColor = MaterialColor.clear
    }
    

    
    fileprivate func prepareItems() {
        defaultCategories.removeAll()
        defaultCategories.append(Category(name: "FOOD"))
        defaultCategories.append(Category(name: "ENTERTAINMENT"))
        defaultCategories.append(Category(name: "RENT"))
        defaultCategories.append(Category(name: "SUBSCRIPTIONS"))
        defaultCategories.append(Category(name: "GROCERIES"))
        defaultCategories.append(Category(name: "UTILITIES"))
        
        for defaultCategory in defaultCategories {
           if categories.contains(where: { (category) -> Bool in category.name == defaultCategory.name }) {
            print(defaultCategory)
            
           } else {
            categories.append(defaultCategory)
            }
        }
        
        categories.sort { (a, b) -> Bool in a.counter > b.counter }
                
        tableView.reloadData()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryCell
        cell.backgroundColor = MaterialColor.clear
        cell.contentView.backgroundColor = MaterialColor.clear
        
        cell.categoryLabel.font = categoryFont
        cell.categoryLabel.textColor = MaterialColor.white
        if (indexPath as NSIndexPath).row == categories.count {
            cell.categoryLabel.text = addNewText
            return cell
        }
        let category = categories[(indexPath as NSIndexPath).row]
        print(category)
        cell.categoryLabel.text = category.name.uppercased()
        return cell
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count + 1
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).row != categories.count {
            if let category = (categories[(indexPath as NSIndexPath).row]).name as String? {
                switch expenseType {
                case .user:
                    if let finishVC = self.storyboard?.instantiateViewController(withIdentifier: "finishViewController") as? FinishViewController {
                        newExpense.category = category
                        finishVC.newExpense = newExpense
                        self.navigationController?.pushViewController(finishVC, animated: true)
                    }
                    
                case .group:
                    if let parityViewController = self.storyboard?.instantiateViewController(withIdentifier: "parityViewController") as? ParityViewController {
                        newGroupExpense.category = category
                        parityViewController.newGroupExpense = newGroupExpense
                        //                    ParityViewController.expenseType = .group //Defaulting to group for now
                        self.navigationController?.pushViewController(parityViewController, animated: true)
                    }
                }
            }
        } else {
            
            if let addExpenseVC = self.storyboard?.instantiateViewController(withIdentifier: "addExpenseController") as? AddExpenseController {
                
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
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! AlphaCollectionCell
        cell.backgroundColor = MaterialColor.clear
        
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 2

        cell.categoryButton.titleLabel?.font = categoryFont
        
        if (indexPath as NSIndexPath).row == categories.count {

            
            cell.categoryButton.setTitle(addNewText.uppercased(), for: .normal)
            
            return cell
        }
        
        let category = categories[(indexPath as NSIndexPath).row]

        cell.categoryButton.setTitle(category.name.uppercased(), for: .normal)
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        if (indexPath as NSIndexPath).row == categories.count {
            let categorySize = (addNewText.uppercased() as NSString).size(attributes: [NSFontAttributeName: categoryFont])
            return CGSize(width: categorySize.width + 40, height: 30)
        } else {
            let category = categories[(indexPath as NSIndexPath).row]
            let categorySize = (category.name.uppercased() as NSString).size(attributes: [NSFontAttributeName: categoryFont])
            return CGSize(width: categorySize.width + 40, height: 30)
        }
        
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
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
        if (indexPath as NSIndexPath).row != categories.count {
            if let category = (categories[(indexPath as NSIndexPath).row]).name as String? {
                switch expenseType {
                case .user:
                    if let finishVC = self.storyboard?.instantiateViewController(withIdentifier: "finishViewController") as? FinishViewController {
                        newExpense.category = category
                        finishVC.newExpense = newExpense
                        self.navigationController?.pushViewController(finishVC, animated: true)
                    }
                    
                case .group:
                    if let parityViewController = self.storyboard?.instantiateViewController(withIdentifier: "parityViewController") as? ParityViewController {
                        newGroupExpense.category = category
                        parityViewController.newGroupExpense = newGroupExpense
                        //                    ParityViewController.expenseType = .group //Defaulting to group for now
                        self.navigationController?.pushViewController(parityViewController, animated: true)
                    }
                }
            }
        } else {
            
            if let addExpenseVC = self.storyboard?.instantiateViewController(withIdentifier: "addExpenseController") as? AddExpenseController {
                
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
    
    @IBAction func backOneStep(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getMaxCellWidth() -> CGFloat {
        
        var categoryWidths = [CGFloat]()
        
        for category in self.categories {
            let cellSize = (category.name.uppercased() as NSString).size(attributes: [NSFontAttributeName: categoryFont])
            categoryWidths.append(cellSize.width)
        }
        let cellSize = (addNewText.uppercased() as NSString).size(attributes: [NSFontAttributeName: categoryFont])
        categoryWidths.append(cellSize.width)
        
        if categoryWidths.max() != nil {
            return categoryWidths.max()! + 10
        } else {
            return 80
        }
    }
    
    
}




