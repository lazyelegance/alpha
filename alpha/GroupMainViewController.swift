//
//  GroupMainViewController.swift
//  alpha
//
//  Created by Ezra Bathini on 29/07/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import Material
import FirebaseDatabase

class GroupMainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    


    @IBOutlet weak var tableView: UITableView!
    
    var group = Group()
    var groupExpenseTotals = GroupExpenseTotals()
    var groupMembers = [User]()
    var lastExpense = GroupExpense()
    
    var groupId = String()
    var currentUser = User()
    
    
    var firebaseRef = FIRDatabaseReference()

    @IBOutlet weak var groupName: UILabel!
    
    @IBOutlet weak var groupOwing: UILabel!
    
    @IBOutlet weak var groupIcon: AsyncImageView!


    
    @IBOutlet weak var lastExpenseAddedBy: UILabel!
    @IBOutlet weak var lastExpenseAmount: UILabel!
    @IBOutlet weak var lastExpenseDetail: UILabel!
    @IBOutlet weak var lastExpenseView: MaterialView!
    @IBOutlet weak var groupMembersView: MaterialView!
    @IBOutlet weak var groupMembersPlaceholder: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
        getGroupData()
        prepareGroupMembersView()
        prepareLastExpenseView()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Prepare
    
    private func prepareView() {
        view.backgroundColor = MaterialColor.orange.darken1

    }
    
    private func prepareGroupHeaderView() {
        groupName.alpha = 0
        groupOwing.alpha = 0
        groupIcon.alpha = 0
        
        
        
        if group.groupId != "0" {
            groupName.alpha = 1
            groupOwing.alpha = 1
            groupIcon.alpha = 1
            groupName.text = group.name
            groupOwing.text = "Loading"
            if let owing = groupExpenseTotals.owing[currentUser.userId] as Float? {
                groupOwing.text = "You owe the group \(owing) $"
            }
            groupIcon.image = UIImage(named: group.imageString)
        }
        
    }
    
    private func prepareGroupMembersView() {
        
        if groupMembers.count > 0 {
            groupMembersPlaceholder.alpha = 0
            tableView.reloadData()
            tableView.alpha = 1
            tableView.separatorStyle = .None
            
        }
    }
    
    private func prepareLastExpenseView() {
        lastExpenseDetail.text = "Loading.."
        lastExpenseAmount.alpha = 0
        lastExpenseAddedBy.alpha = 0
        
        if lastExpense.expenseId != "0" {
            lastExpenseDetail.text = lastExpense.description
            
            lastExpenseAmount.text = "\(lastExpense.billAmount) $"
            lastExpenseAmount.alpha = 1
            lastExpenseAddedBy.alpha = 1
            
            for groupMember in groupMembers {
                if groupMember.userId == lastExpense.addedBy {
                    lastExpenseAddedBy.text = "added by: \(groupMember.name)"
                }
            }
            
            
            
            
        }
    }
    
    
    // MARK: - Fetch
    
    private func getGroupData() {
        
        if let groupRef = firebaseRef.child("groups/\(groupId)") as FIRDatabaseReference? {
            groupRef.observeSingleEventOfType(.Value, withBlock: { (groupSnapshot) in
                self.group = Group.groupFromFirebase(self.groupId, results: groupSnapshot.value! as! NSDictionary)
                self.prepareGroupHeaderView()
                self.groupMembers.removeAll()
                for member in self.group.members {
                    var user = User()
                    if let userRef = self.firebaseRef.child("users/\(member)") as FIRDatabaseReference? {
                        userRef.observeSingleEventOfType(.Value, withBlock: { (userSnapshot) in
                            user = User.userFromFirebase(userSnapshot.value! as! NSDictionary)
                            self.groupMembers.append(user)
                            self.prepareGroupMembersView()
                        })
                    }
                }
                if let expenseRef = self.firebaseRef.child("groupExpenses/\(self.groupId)/\(self.group.lastExpense)") as FIRDatabaseReference? {
                    print(expenseRef)
                    expenseRef.observeSingleEventOfType(.Value, withBlock: { (expenseSnapshot) in
                        if expenseSnapshot.exists() {
                            self.lastExpense = GroupExpense.expenseFromResults(self.group.lastExpense, results: expenseSnapshot.value! as! NSDictionary)
                            self.prepareLastExpenseView()
                        }
                    })
                }
            })
        }

        if let groupExpensesTotalsRef = firebaseRef.child("groupExpenses/\(groupId)/totals") as FIRDatabaseReference? {
            print(groupExpensesTotalsRef)
            groupExpensesTotalsRef.observeSingleEventOfType(.Value, withBlock: { (expenseTotals) in
                self.groupExpenseTotals = GroupExpenseTotals.totalsFromResults(self.groupId, results: expenseTotals.value! as! NSDictionary)
                self.prepareGroupHeaderView()
            })
        }
    }
    


    

    // MARK: - TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupMembers.count;
    }
    
    /// Returns the number of sections.
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    /// Prepares the cells within the tableView.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: MaterialTableViewCell = MaterialTableViewCell(style: .Subtitle, reuseIdentifier: "memberCell")
        
        let groupMember = groupMembers[indexPath.row]
        cell.selectionStyle = .None
        cell.textLabel!.text = groupMember.name
        cell.textLabel!.font = RobotoFont.regular
        
        cell.detailTextLabel?.text = groupMember.title
        cell.detailTextLabel!.font = RobotoFont.regular
        cell.detailTextLabel!.textColor = MaterialColor.grey.darken1
        cell.imageView?.image = UIImage(named: "default_user")
        cell.imageView!.imageURL = NSURL(string: groupMember.photoURL)
        cell.imageView?.layer.masksToBounds = true
        
        cell.imageView!.layer.cornerRadius = 5
        cell.imageView!.layer.borderColor = MaterialColor.white.CGColor
        cell.imageView?.layer.borderWidth = 5
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //to do 
        //to profile view

    }
    
    // MARK: - Buttons
    
    @IBAction func seeAllGroupExpenses(sender: AnyObject) {
        if let expensesListViewController = self.storyboard?.instantiateViewControllerWithIdentifier("expensesListViewController") as? ExpensesListViewController {
            expensesListViewController.expenseType = .user
            expensesListViewController.expensesRef = self.firebaseRef.child("groupExpenses/\(groupId)")
            self.navigationController?.pushViewController(expensesListViewController, animated: true)
        }
    }
    
    
    @IBAction func addGroupExpense(sender: AnyObject) {
        //to do
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
