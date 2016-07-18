//
//  AddExpenseController.swift
//  alpha
//
//  Created by Ezra Bathini on 16/07/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import Material

class AddExpenseController: UIViewController, UITextFieldDelegate {
    
    var placeHolderText = "Description"
    var nextPlaceHolder = "Bill Amount"
    var currentStep = AddExpenseStep.description
    
    var currAmountOwing = "0.00"

    
    var descriptionTextField: TextField!
    
    
    var nextButton: FlatButton!
    
    var backButton: FlatButton!
    
    var startOverButton: FlatButton!
    
    var newExpense = Expense()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = currentStep.toColor()
        
        
        descriptionTextField = TextField(frame: CGRectMake(10, 100, self.view.frame.width - 20, 50))
        nextButton = FlatButton(frame: CGRectMake(self.view.frame.width - 100, 160 , 60, 60))
        backButton = FlatButton(frame: CGRectMake(self.view.frame.width - 180, 160, 60, 60))
        
        
        
        descriptionTextField.placeholder = currentStep.toString()
        descriptionTextField.placeholderColor = MaterialColor.white
        descriptionTextField.backgroundColor = currentStep.toColor()
        descriptionTextField.textColor = MaterialColor.white
        descriptionTextField.font = RobotoFont.lightWithSize(20)
        
        descriptionTextField.delegate = self
        
        descriptionTextField.addTarget(self, action: #selector(AddExpenseController.toNextInAddExpenseCycle), forControlEvents: .EditingDidEndOnExit)
        descriptionTextField.addTarget(self, action: #selector(AddExpenseController.showNextButton), forControlEvents: .EditingChanged)
        
        descriptionTextField.becomeFirstResponder()
        
        nextButton.backgroundColor = MaterialColor.white
        
        if currentStep == .finish {
            nextButton.setTitle("FINISH", forState: .Normal)
        } else {
            nextButton.setTitle("NEXT", forState: .Normal)
        }
        
        
        
        nextButton.setTitleColor(MaterialColor.blue.accent1, forState: .Normal)
        nextButton.titleLabel?.font = RobotoFont.regularWithSize(8)
        nextButton.pulseColor = MaterialColor.blue.accent3
        
        nextButton.tintColor = MaterialColor.blue.accent3
        
        nextButton.layer.cornerRadius = 30
        
        nextButton.layer.shadowOpacity = 0.1
        
        nextButton.addTarget(self, action: #selector(AddExpenseController.toNextInAddExpenseCycle), forControlEvents: .TouchUpInside)
        
        nextButton.alpha = 0
        
        backButton.backgroundColor = MaterialColor.white
    
        backButton.setTitle("BACK", forState: .Normal)
        backButton.setTitleColor(MaterialColor.blue.accent1, forState: .Normal)
        backButton.titleLabel?.font = RobotoFont.regularWithSize(8)
        backButton.layer.cornerRadius = 30
        
        backButton.addTarget(self, action: #selector(AddExpenseController.backOneStep), forControlEvents: .TouchUpInside)

        let image = UIImage(named: "ic_close_white")?.imageWithRenderingMode(.Automatic)
        let clearButton: FlatButton = FlatButton()
        clearButton.pulseColor = MaterialColor.grey.base
        clearButton.tintColor = MaterialColor.grey.base
        clearButton.setImage(image, forState: .Normal)
        clearButton.setImage(image, forState: .Highlighted)
        
        view.addSubview(descriptionTextField)
        view.addSubview(nextButton)
        view.addSubview(backButton)
        
//        descriptionTextField.clearIconButton = clearButton

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func toNextInAddExpenseCycle() {
        
        descriptionTextField.resignFirstResponder()
        
        if descriptionTextField.text?.isEmpty == false {
            switch currentStep {
            case .description:
                newExpense.description = descriptionTextField.text!
            case .billAmount:
                newExpense.billAmount = (descriptionTextField.text! as NSString).floatValue
            default:
                return
            }
            
            if currentStep.nextStep() == .parity {
                if let parityVC = self.storyboard?.instantiateViewControllerWithIdentifier("parityViewController") as? ParityViewController {
                    parityVC.currentStep = self.currentStep.nextStep()
                    parityVC.newExpense = self.newExpense
                    self.navigationController?.pushViewController(parityVC, animated: true)
                    
                }
            } else {
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
