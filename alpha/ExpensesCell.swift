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
    
    
    @IBOutlet weak var addedDatelabel: UILabel!
    
    
    let clearColor = UIColor.clearColor()
    var expense: GroupExpense? {
        didSet {
            if let item = expense {
                self.backgroundColor = MaterialColor.indigo.accent4
                self.contentView.backgroundColor = clearColor
                descriptionLabel.backgroundColor = clearColor
                billAmountLabel.backgroundColor = clearColor
                addedDatelabel.backgroundColor = clearColor
                addedByLabel.backgroundColor = clearColor
                
                descriptionLabel.text = item.description
                billAmountLabel.text = "$ \(item.billAmount)"
                addedByLabel.text = "added By : " + item.addedBy
                addedDatelabel.text = "on " + item.dateAdded
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
