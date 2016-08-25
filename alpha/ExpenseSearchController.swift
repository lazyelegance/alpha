//
//  ExpenseSearchController.swift
//  alpha
//
//  Created by Ezra Bathini on 15/08/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import Material

protocol ExpenseSearchControllerDelegate {
    func didStartSearching()
    
    func didTapOnSearchButton()
    
    func didTapOnCancelButton()
    
    func didChangeSearchText(searchText: String)
}

class ExpenseSearchController: UISearchController, UISearchBarDelegate {
    
    var expenseSearchBar: ExpenseSearchBar!
    var expenseSearchDelete: ExpenseSearchControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    init(searchResultsController: UIViewController!, searchBarFrame: CGRect, searchBarFont: UIFont, searchBarTextColor: UIColor, searchBarTintColor: UIColor) {
        super.init(searchResultsController: searchResultsController)
        
        configureSearchBar(searchBarFrame, font: searchBarFont, textColor: searchBarTextColor, bgColor: searchBarTintColor)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func configureSearchBar(frame: CGRect, font: UIFont, textColor: UIColor, bgColor: UIColor) {
        expenseSearchBar = ExpenseSearchBar(frame: frame, font: font , textColor: textColor)
        
        expenseSearchBar.barTintColor = bgColor
        expenseSearchBar.tintColor = textColor
        expenseSearchBar.showsBookmarkButton = false
        expenseSearchBar.showsCancelButton = false
        expenseSearchBar.delegate = self
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        expenseSearchDelete.didStartSearching()
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        expenseSearchBar.resignFirstResponder()
        expenseSearchDelete.didTapOnSearchButton()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        expenseSearchBar.resignFirstResponder()
        expenseSearchDelete.didTapOnCancelButton()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        expenseSearchDelete.didChangeSearchText(searchText)
    }
    

    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
