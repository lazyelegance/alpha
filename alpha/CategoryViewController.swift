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

class CategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    

    
    private var categories: Array<Category> = Array<Category>()
    
    
    
    var newExpense = Expense()
    var newGroupExpense = GroupExpense()
    var currentStep = AddExpenseStep.category
    var expenseType: ExpenseType = .user
    
    @IBOutlet weak var backButton: FabButton!
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
    }
    

    
    private func prepareItems() {
        categories.append(Category(text: "Food", detail: ".", image: UIImage(named: "eggs")))
        categories.append(Category(text: "Rent", detail: "?", image: UIImage(named: "chair")))
        categories.append(Category(text: "Entertainment", detail: ".", image: UIImage(named: "theatre")))
        categories.append(Category(text: "Groceries", detail: "?", image: UIImage(named: "store")))
        categories.append(Category(text: "Fuel", detail: "?", image: UIImage(named: "car")))
        categories.append(Category(text: "Subscriptions", detail: "?", image: UIImage(named: "youtube")))
        
        collectionView.reloadData()
        
    }
    

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count + 1
        
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("categoryCell", forIndexPath: indexPath) as! CategoryCell
        cell.backgroundColor = MaterialColor.white
        
        if indexPath.row == categories.count {
            cell.categoryLabel.text = "+ Add New"
            cell.categoryImage.image = UIImage(named: "tick")
            cell.backgroundColor = MaterialColor.blueGrey.lighten5
            
            return cell
        }
        
        let category = categories[indexPath.row]
        
        cell.categoryImage.image = category.image
        cell.categoryLabel.text = category.text
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(80, 80)
        
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10.0
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row != categories.count {
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
}




