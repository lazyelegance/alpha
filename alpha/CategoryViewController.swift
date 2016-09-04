//
//  CategoryViewController.swift
//  alpha
//
//  Created by Ezra Bathini on 27/07/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import Material



class CategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    

    
    var categories = [Category]()
    
    
    
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
        
                
        collectionView.reloadData()
        
    }
    

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count + 1
        
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("categoryCell", forIndexPath: indexPath) as! AlphaCollectionCell
        cell.backgroundColor = MaterialColor.white
        
        cell.nameLabel.textColor = MaterialColor.black
        
        
        if indexPath.row == categories.count {
            cell.nameLabel.text = "+ Add New"
            cell.imageView.image = UIImage(named: "addnew")
            cell.nameLabel.textColor = MaterialColor.blue.darken1
            
            return cell
        }
        
        let category = categories[indexPath.row]
        
        cell.imageView.image = UIImage(named: category.imageName)
        cell.nameLabel.text = category.name
        
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
}




