//
//  GroupExpenseCell.swift
//  alpha
//
//  Created by Ezra Bathini on 10/08/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import Material

class GroupExpenseCell: MaterialTableViewCell {
    
    @IBOutlet weak var expenseImageView: UIImageView!
    
    @IBOutlet weak var expenseDescription: UILabel!
    
    @IBOutlet weak var billAmountLabel: UILabel!
    
    @IBOutlet weak var categoryButton: FlatButton!
    
    @IBOutlet weak var dateAddedLabel: UILabel!
    
    var groupExpense: GroupExpense? {
        didSet {
            if let item = groupExpense {
                
                //expenseImageView.image = UIImage(named: "discounts-marker")
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
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}