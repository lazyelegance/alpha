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
        
        view.backgroundColor = currentStep.toColor()

        print(currentStep.toString().uppercaseString)
        expenseTextField.placeholder = currentStep.toString()
//        expenseTextField.placeholderColor = MaterialColor.white
//        expenseTextField.backgroundColor = currentStep.toColor()
        expenseTextField.textColor = MaterialColor.white
        expenseTextField.font = RobotoFont.lightWithSize(20)
        expenseTextField.dividerColor = MaterialColor.white
        
        
//        expenseTextField.delegate = self
        
        expenseTextField.addTarget(self, action: #selector(AddExpenseController.toNextInAddExpenseCycle), forControlEvents: .EditingDidEndOnExit)
        expenseTextField.addTarget(self, action: #selector(AddExpenseController.showNextButton), forControlEvents: .EditingChanged)
        
        
        expenseTextField.keyboardType = UIKeyboardType.Alphabet
        expenseTextField.keyboardAppearance = .Light
        
        
        
        backButton.setImage(MaterialIcon.arrowBack, forState: .Normal)
        
        nextButton.alpha = 0
        
        switch currentStep {
        case .billAmount:
            nextButton.setTitle("next".uppercaseString, forState: .Normal)
            expenseTextField.keyboardType = UIKeyboardType.DecimalPad
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
        
        expenseTextField.becomeFirstResponder()
        
        nextButton.addTarget(self, action: #selector(AddExpenseController.toNextInAddExpenseCycle), forControlEvents: .TouchUpInside)
        backButton.addTarget(self, action: #selector(AddExpenseController.backOneStep), forControlEvents: .TouchUpInside)
        

        let image = UIImage(named: "ic_close_white")?.imageWithRenderingMode(.Automatic)
        let clearButton: FlatButton = FlatButton()
        clearButton.pulseColor = MaterialColor.grey.base
        clearButton.tintColor = MaterialColor.grey.base
        clearButton.setImage(image, forState: .Normal)
        clearButton.setImage(image, forState: .Highlighted)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func toNextInAddExpenseCycle() {
        
        expenseTextField.resignFirstResponder()
        
        if expenseTextField.text?.isEmpty == false {
            switch currentStep {
            case .description:
                newExpense.description = expenseTextField.text!
            case .billAmount:
                newExpense.billAmount = (expenseTextField.text! as NSString).floatValue
            case .category:
                newExpense.category = expenseTextField.text!
            default:
                return
            }
            
            
            switch currentStep.nextStep() {
            case .parity:
                if let parityVC = self.storyboard?.instantiateViewControllerWithIdentifier("parityViewController") as? ParityViewController {
                    parityVC.currentStep = self.currentStep.nextStep()
                    parityVC.newExpense = self.newGroupExpense
                    self.navigationController?.pushViewController(parityVC, animated: true)
                    
                }
            case .finish:
                if let finishVC = self.storyboard?.instantiateViewControllerWithIdentifier("finishViewController") as? FinishViewController {
                    
                    
                    finishVC.newExpense = self.newExpense
                    self.navigationController?.pushViewController(finishVC, animated: true)
                }
            case .category:
                if let categoryVC = self.storyboard?.instantiateViewControllerWithIdentifier("categoryViewController") as? CategoryViewController {
                    categoryVC.newExpense = self.newExpense
                    self.navigationController?.pushViewController(categoryVC, animated: true)
                    
                }
                
            default:
                if let addExpenseVC = self.storyboard?.instantiateViewControllerWithIdentifier("addExpenseController") as? AddExpenseController {
                    addExpenseVC.currentStep = self.currentStep.nextStep()
                    addExpenseVC.newExpense = self.newExpense
                    self.navigationController?.pushViewController(addExpenseVC, animated: true)
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
