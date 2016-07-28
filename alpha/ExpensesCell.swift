//
//  ExpensesCell.swift
//  alpha
//
//  Created by Ezra Bathini on 19/07/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import Material

class ExpensesCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var billAmountLabel: UILabel!
    
    @IBOutlet weak var addedByLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    
    @IBOutlet weak var addedMonth: UILabel!

    @IBOutlet weak var addedDay: UILabel!
    
    @IBOutlet weak var addedYear: UILabel!
    
    @IBOutlet weak var materialView: MaterialView!
    
    @IBOutlet weak var dateView: MaterialView!
    let clearColor = UIColor.clearColor()
    var expense: Expense? {
        didSet {
            if let item = expense {
                self.backgroundColor = MaterialColor.teal.lighten1
                self.contentView.backgroundColor = clearColor
               
                materialView.backgroundColor = self.backgroundColor
                
                
                descriptionLabel.backgroundColor = clearColor
                billAmountLabel.backgroundColor = clearColor
                categoryLabel.backgroundColor = clearColor
                
                descriptionLabel.text = item.description
                billAmountLabel.text = "$ \(item.billAmount)"
                categoryLabel.text =  item.category
                
                
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            
                if let itemdate = formatter.dateFromString(item.dateAdded) {
                    
                    dateView.backgroundColor = self.backgroundColor
                    dateView.shape = .Circle
                    
                    formatter.dateFormat = "dd"
                    addedDay.text = formatter.stringFromDate(itemdate)
                    formatter.dateFormat = "MMMM"
                    addedMonth.text = formatter.stringFromDate(itemdate)
                    formatter.dateFormat = "yyyy"
                    addedYear.text = formatter.stringFromDate(itemdate)
                } else {
                    dateView.alpha = 0
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
