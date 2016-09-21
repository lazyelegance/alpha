//
//  ExpenseCell.swift
//  alpha
//
//  Created by Ezra Bathini on 30/07/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit

protocol ExpenseCellDelegate {
    func deleteUserExpense(_ expense: Expense)
}

class ExpenseCell: MaterialTableViewCell {

    @IBOutlet weak var expenseImageView: UIImageView!
    
    @IBOutlet weak var expenseDescription: UILabel!
    
    @IBOutlet weak var billAmountLabel: UILabel!
    
    @IBOutlet weak var categoryButton: FlatButton!
    
    @IBOutlet weak var dateAddedLabel: UILabel!
    
    @IBOutlet weak var dollarSignLabel: UILabel!

    
    var expenseCellDelegate: ExpenseCellDelegate?
    
    var expense: Expense? {
        didSet {
            if let item = expense {


                //expenseImageView.image = UIImage(named: "discounts-marker")
                expenseDescription.text = item.description
                billAmountLabel.text = "\(item.billAmount)"
                
                categoryButton.setTitle(item.category.uppercased(), for: .normal)
                categoryButton.setTitleColor(MaterialColor.blueGrey.lighten1, for: .normal)
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                
                if let itemdate = formatter.date(from: item.dateAdded) {
                    formatter.dateFormat = "dd MMM yyyy"
                    dateAddedLabel.text = formatter.string(from: itemdate)
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
