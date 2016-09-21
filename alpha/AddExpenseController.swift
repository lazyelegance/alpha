//
//  AddExpenseController.swift
//  alpha
//
//  Created by Ezra Bathini on 16/07/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit


class AddExpenseController: UIViewController, UITextFieldDelegate {
    
    var newExpense = Expense()
    var newGroupExpense = GroupExpense()
    var categories = [Category]()
    
    
    var currentStep = AddExpenseStep.description
    var expenseType: ExpenseType = .user
    var currAmountOwing = "0.00"


    
    @IBOutlet weak var expenseTextField: UITextField!
    @IBOutlet weak var nextButton: FlatButton!
    
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
    
    fileprivate func prepareView() {
//        view.backgroundColor = currentStep.toColor()
    }
    
    fileprivate func prepareTextField() {
        
        
        expenseTextField.placeholder = currentStep.toString()
//        expenseTextField.detail = currentStep.toString()
//        expenseTextField.placeholderColor = MaterialColor.white
//        expenseTextField.textColor = MaterialColor.white
//        expenseTextField.font = RobotoFont.lightWithSize(20)
//        expenseTextField.dividerColor = MaterialColor.white
//        expenseTextField.placeholderActiveColor = MaterialColor.yellow.accent1
//        
//        
//        expenseTextField.placeholderColor = MaterialColor.amber.darken4
//        expenseTextField.placeholderActiveColor = MaterialColor.pink.base
//        expenseTextField.dividerColor = MaterialColor.cyan.base
        
        
        expenseTextField.addTarget(self, action: #selector(AddExpenseController.toNextInAddExpenseCycle), for: .editingDidEndOnExit)
        expenseTextField.addTarget(self, action: #selector(AddExpenseController.showNextButton), for: .editingChanged)
        expenseTextField.keyboardType = UIKeyboardType.alphabet
        
        if currentStep == .billAmount {
             expenseTextField.keyboardType = UIKeyboardType.decimalPad
        }
        expenseTextField.delegate = self
        expenseTextField.keyboardAppearance = .light
        expenseTextField.becomeFirstResponder()
    }
    
    fileprivate func prepareButtons() {
        
        
        nextButton.alpha = 0
        switch currentStep {
        case .description:
            nextButton.setTitle("add expense amount".uppercased(), for: .normal)
            
        case .billAmount:
            nextButton.setTitle("add category".uppercased(), for: .normal)
            
        case .category:
            nextButton.setTitle("finish adding expense".uppercased(), for: .normal)
            
        default:
            break
        }
        
    
        nextButton.setTitleColor(MaterialColor.blue.darken2, for: .normal)
        nextButton.backgroundColor = MaterialColor.white
        
        nextButton.addTarget(self, action: #selector(AddExpenseController.toNextInAddExpenseCycle), for: .touchUpInside)
        backButton.setImage(MaterialIcon.arrowBack, for: .normal)
        backButton.addTarget(self, action: #selector(AddExpenseController.backOneStep), for: .touchUpInside)
    }
    
    
    

    


    
    func toNextInAddExpenseCycle() {
        
        expenseTextField.resignFirstResponder()
        
        if expenseTextField.text?.isEmpty == false {
            if currentStep == .description {
                if let addExpenseVC = self.storyboard?.instantiateViewController(withIdentifier: "addExpenseController") as? AddExpenseController {
                    
                    addExpenseVC.currentStep = .billAmount
                    addExpenseVC.expenseType = expenseType
                    addExpenseVC.categories = categories
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
                if let categoryViewController = self.storyboard?.instantiateViewController(withIdentifier: "categoryViewController") as? CategoryViewController {
                    
                    categoryViewController.currentStep = .category
                    categoryViewController.expenseType = expenseType
                    categoryViewController.categories = categories
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
            } else if currentStep == .category {
                
                switch expenseType {
                case .user:
                    if let finishVC = self.storyboard?.instantiateViewController(withIdentifier: "finishViewController") as? FinishViewController {
                        newExpense.category = expenseTextField.text!.uppercased()
                        finishVC.newExpense = newExpense
                        self.navigationController?.pushViewController(finishVC, animated: true)
                    }
                    
                case .group:
                    if let parityViewController = self.storyboard?.instantiateViewController(withIdentifier: "parityViewController") as? ParityViewController {
                        newGroupExpense.category = expenseTextField.text!.uppercased()
                        parityViewController.newGroupExpense = newGroupExpense
                        //                    ParityViewController.expenseType = .group //Defaulting to group for now
                        self.navigationController?.pushViewController(parityViewController, animated: true)
                    }
                }
            }
        }

    }
    
    func showNextButton() {
        nextButton.alpha = 1
    }
    
    func backOneStep() {
        print("back button")
        navigationController?.popViewController(animated: true)
    }

    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //(textField as? ErrorTextField)?.revealError = false
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        //(textField as? ErrorTextField)?.revealError = false
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //(textField as? ErrorTextField)?.revealError = false
        return true
    }

}
