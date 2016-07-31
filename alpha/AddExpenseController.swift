//
//  AddExpenseController.swift
//  alpha
//
//  Created by Ezra Bathini on 16/07/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import Material

class AddExpenseController: UIViewController, TextFieldDelegate {
    
    var newExpense = Expense()
    var newGroupExpense = GroupExpense()
    var currentStep = AddExpenseStep.description
    var expenseType: ExpenseType = .user
    var currAmountOwing = "0.00"


    
    @IBOutlet weak var expenseTextField: TextField!
    @IBOutlet weak var nextButton: RaisedButton!
    
    @IBOutlet weak var backButton: FabButton!
    
    
    var startOverButton: FlatButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareView()
        prepareTextField()
        prepareButtons()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func prepareView() {
        view.backgroundColor = currentStep.toColor()
    }
    
    private func prepareTextField() {
        
        
        expenseTextField.placeholder = currentStep.toString()
        expenseTextField.placeholderColor = MaterialColor.white
        expenseTextField.textColor = MaterialColor.white
        expenseTextField.font = RobotoFont.lightWithSize(20)
        expenseTextField.dividerColor = MaterialColor.white
        expenseTextField.placeholderActiveColor = MaterialColor.yellow.accent1
        
        
        expenseTextField.addTarget(self, action: #selector(AddExpenseController.toNextInAddExpenseCycle), forControlEvents: .EditingDidEndOnExit)
        expenseTextField.addTarget(self, action: #selector(AddExpenseController.showNextButton), forControlEvents: .EditingChanged)
        expenseTextField.keyboardType = UIKeyboardType.Alphabet
        if currentStep == .billAmount {
             expenseTextField.keyboardType = UIKeyboardType.DecimalPad
        }
        expenseTextField.delegate = self
        expenseTextField.keyboardAppearance = .Light
        expenseTextField.becomeFirstResponder()
    }
    
    private func prepareButtons() {
        
        
        nextButton.alpha = 0
        switch currentStep {
        case .billAmount:
            nextButton.setTitle("next".uppercaseString, forState: .Normal)
           
            nextButton.backgroundColor = MaterialColor.amber.darken2
        case .description:
            nextButton.setTitle("add expense amount".uppercaseString, forState: .Normal)
            nextButton.backgroundColor = MaterialColor.blue.darken2
        case .category:
            nextButton.setTitle("finish adding expense".uppercaseString, forState: .Normal)
            nextButton.backgroundColor = MaterialColor.blue.darken2
        default:
            break
        }
        nextButton.setTitleColor(MaterialColor.white, forState: .Normal)
        nextButton.backgroundColor = view.backgroundColor
        nextButton.addTarget(self, action: #selector(AddExpenseController.toNextInAddExpenseCycle), forControlEvents: .TouchUpInside)
        
        
        
        backButton.setImage(MaterialIcon.arrowBack, forState: .Normal)
        backButton.addTarget(self, action: #selector(AddExpenseController.backOneStep), forControlEvents: .TouchUpInside)
    }
    
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    


    
    func toNextInAddExpenseCycle() {
        
        expenseTextField.resignFirstResponder()
        
        if expenseTextField.text?.isEmpty == false {
            if currentStep == .description {
                if let addExpenseVC = self.storyboard?.instantiateViewControllerWithIdentifier("addExpenseController") as? AddExpenseController {
                    
                    addExpenseVC.currentStep = .billAmount
                    addExpenseVC.expenseType = self.expenseType
                    switch expenseType {
                    case .user:
                        newExpense.description = expenseTextField.text!
                        addExpenseVC.newExpense = self.newExpense
                    case .group:
                        newGroupExpense.description = expenseTextField.text!
                        addExpenseVC.newGroupExpense = self.newGroupExpense
                    }
                    self.navigationController?.pushViewController(addExpenseVC, animated: true)
                }
            } else if currentStep == .billAmount {
                if let categoryViewController = self.storyboard?.instantiateViewControllerWithIdentifier("categoryViewController") as? CategoryViewController {
                    
                    categoryViewController.currentStep = .category
                    categoryViewController.expenseType = self.expenseType
                    switch expenseType {
                    case .user:
                        newExpense.billAmount = (expenseTextField.text! as NSString).floatValue
                        categoryViewController.newExpense = self.newExpense
                    case .group:
                        newGroupExpense.billAmount = (expenseTextField.text! as NSString).floatValue
                        categoryViewController.newGroupExpense = self.newGroupExpense
                    }
                    self.navigationController?.pushViewController(categoryViewController, animated: true)
                }
            }
        }

    }
    
    func showNextButton() {
        nextButton.alpha = 1
    }
    
    func backOneStep() {
        print("back button")
        navigationController?.popViewControllerAnimated(true)
    }


}
