//
//  GroupExpenseCell.swift
//  alpha
//
//  Created by Ezra Bathini on 10/08/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import Material

protocol GroupExpenseCellDelegate {
    func deleteGroupExpense(groupExpense: GroupExpense)
}

class GroupExpenseCell: MaterialTableViewCell {
    
    @IBOutlet weak var expenseImageView: UIImageView!
    
    @IBOutlet weak var expenseDescription: UILabel!
    
    @IBOutlet weak var billAmountLabel: UILabel!
    
    @IBOutlet weak var categoryButton: FlatButton!
    
    @IBOutlet weak var dateAddedLabel: UILabel!
    
    @IBOutlet weak var editStack: UIStackView!
    
    @IBOutlet weak var areYouSureButton: UILabel!
    
    @IBOutlet weak var dollarSignLabel: UILabel!
    
    
    @IBOutlet weak var editButton1: RaisedButton!
    
    @IBOutlet weak var editButton2: RaisedButton!
    
    enum DeleteButtonState {
        case delete
        case confirm
    }
    
    var groupExpenseCellDelegate: GroupExpenseCellDelegate?
    
    var deleteButtonState = DeleteButtonState.delete
    
    var groupExpense: GroupExpense? {
        didSet {
            if let item = groupExpense {
                
                editStack.alpha = 0
                areYouSureButton.alpha = 0
                expenseDescription.text = item.description
                billAmountLabel.text = "\(item.billAmount)"
                
                categoryButton.setTitle(item.category.uppercaseString, forState: .Normal)
                categoryButton.setTitleColor(MaterialColor.blueGrey.lighten1, forState: .Normal)
                
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                
                if let itemdate = formatter.dateFromString(item.dateAdded) {
                    formatter.dateFormat = "dd MMM yyyy"
                    dateAddedLabel.text = formatter.stringFromDate(itemdate)
                } else {
                    dateAddedLabel.alpha = 0
                }
            }
        }
    }
    
    
    func toggleEditStack() {
        if editStack.alpha == 0 {
            editStack.alpha = 1
            dollarSignLabel.alpha = 0.1
            expenseDescription.alpha = 0.3
            billAmountLabel.alpha = 0.3
            dateAddedLabel.alpha = 0.3
        } else {
            editStack.alpha = 0
            expenseDescription.alpha = 1
            billAmountLabel.alpha = 1
            dateAddedLabel.alpha = 1
            dollarSignLabel.alpha = 1
            areYouSureButton.alpha = 0
            deleteButtonState = .delete
            editButton1.setTitle("EDIT", forState: .Normal)
            editButton2.setTitle("DELETE", forState: .Normal)
        }
    }
    
    
    @IBAction func deleteExpense(sender: AnyObject) {
        if deleteButtonState == .delete {
            areYouSureButton.alpha = 1
            editButton1.setTitle("NO", forState: .Normal)
            editButton2.setTitle("YES", forState: .Normal)
            deleteButtonState = .confirm
        } else {
            print("deleting")
            areYouSureButton.alpha = 0
            deleteButtonState = .delete
            groupExpenseCellDelegate?.deleteGroupExpense(self.groupExpense!)
        }
        
    }
    
    
    @IBAction func editButton1Action(sender: AnyObject) {
        if deleteButtonState == .delete {
            
        } else {
            toggleEditStack()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}