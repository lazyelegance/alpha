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

class GroupMainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    

    @IBOutlet weak var collectionView: UICollectionView!

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
            
            collectionView.reloadData()
            collectionView.alpha = 1
            
        }
    }
    
    private func prepareLastExpenseView() {
        lastExpenseDetail.text = "Loading.."
        lastExpenseAmount.alpha = 0
        lastExpenseAddedBy.alpha = 0
        
        if lastExpense.expenseId != "0" && groupMembers.count > 0 {
            
            print(lastExpense)
            lastExpenseDetail.text = lastExpense.description
            
            lastExpenseAmount.text = "\(lastExpense.billAmount) $"
            lastExpenseAmount.alpha = 1
            
            
            for groupMember in groupMembers {
                if groupMember.userId == lastExpense.addedBy {
                    lastExpenseAddedBy.alpha = 1
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
                            self.prepareLastExpenseView()
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
        
            groupExpensesTotalsRef.observeSingleEventOfType(.Value, withBlock: { (expenseTotals) in
                if expenseTotals.exists() {
                    self.groupExpenseTotals = GroupExpenseTotals.totalsFromResults(self.groupId, results: expenseTotals.value! as! NSDictionary)
                    self.prepareGroupHeaderView()
                } else {
                    self.groupOwing.text = "group doesnt have expenses"
                }
            })
        }
    }
    

    // MARK: - CollectionView
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupMembers.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("memberCell", forIndexPath: indexPath) as! AlphaCollectionCell
        cell.backgroundColor = MaterialColor.white
        
        cell.nameLabel.textColor = MaterialColor.black
        
        
        let groupMember = groupMembers[indexPath.row]
        
        cell.imageView.image = UIImage(named: "default_user")

        
        if let photoURL = groupMember.photoURL as String? {
            if photoURL != "" {
                cell.imageView.imageURL = NSURL(string: photoURL)
            } 
        }
        
        
        cell.nameLabel.text = groupMember.name
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(100, 100)
        
    }

    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10.0
    }
    
    // MARK: - Buttons
    
    @IBAction func seeAllGroupExpenses(sender: AnyObject) {
        if let expensesListViewController = self.storyboard?.instantiateViewControllerWithIdentifier("expensesListViewController") as? ExpensesListViewController {
            expensesListViewController.expenseType = .group
            expensesListViewController.groupExpensesRef = self.firebaseRef.child("groupExpenses/\(groupId)")
            expensesListViewController.groupName = self.group.name
            self.navigationController?.pushViewController(expensesListViewController, animated: true)
        }
    }
    
    
    @IBAction func addGroupExpense(sender: AnyObject) {
        //to do
        if let addExpenseVC = self.storyboard?.instantiateViewControllerWithIdentifier("addExpenseController") as? AddExpenseController {

            var owing = [String : Float]()
            owing.removeAll()
            
            for member in groupMembers {
                print(member.amountOwing[self.groupId])
                if member.amountOwing[self.groupId] != nil {
                    owing[member.userId] = member.amountOwing[self.groupId]
                } else {
                    owing[member.userId] = 0.0
                }
                
                
            }
            
            var newGroupExpense = GroupExpense()
            newGroupExpense.groupId = self.groupId
            newGroupExpense.firebaseDBRef = firebaseRef
            newGroupExpense.group = self.group.name
            newGroupExpense.groupMembers = groupMembers
            newGroupExpense.owing = owing
            newGroupExpense.addedBy = currentUser.userId
            
            addExpenseVC.newGroupExpense = newGroupExpense
            addExpenseVC.currentStep = AddExpenseStep.description
            addExpenseVC.expenseType = ExpenseType.group
            self.navigationController?.pushViewController(addExpenseVC, animated: true)
        }
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
