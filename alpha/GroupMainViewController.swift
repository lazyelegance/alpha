//
//  GroupMainViewController.swift
//  alpha
//
//  Created by Ezra Bathini on 29/07/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import Charts
import FirebaseDatabase



class GroupMainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, ChartViewDelegate {
    

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
    
    @IBOutlet weak var groupChartView: PieChartView!
    
    var expenseCategories = [String: [String: Float]]()
    var expenseCategoriesTotal = [String: Float]()
    var expenseCategoriesThisMonth = [String: Float]()
    var expenseCategoriesThisWeek = [String: Float]()
    var yVals = [BarChartDataEntry]()
    var xVals = [String]()
    
    var segmentButtonState = SegmentButtonState.total
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
        getGroupData()
        prepareGroupMembersView()
        prepareLastExpenseView()
        prepareChartView()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Prepare
    
    fileprivate func prepareView() {
        view.backgroundColor = MaterialColor.orange.darken1

    }
    
    fileprivate func prepareGroupHeaderView() {
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
    
    fileprivate func prepareGroupMembersView() {
        
        if groupMembers.count > 0 {
            
            collectionView.reloadData()
            collectionView.alpha = 1
            
        }
    }
    
    fileprivate func prepareLastExpenseView() {
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
    
    fileprivate func prepareExpenseCategories(_ expensesRef: FIRDatabaseReference) {
        self.expenseCategories.removeAll()
        expensesRef.child("categories").observe(.value, with: { (categoriessnapshot) in
            if categoriessnapshot.exists() {
                self.expenseCategories = GroupExpense.categoriesFromResults(categoriessnapshot.value! as! NSDictionary)
                self.updateGraphData()
            } else {
                
            }
        })
    }
    
    fileprivate func prepareLastExpense(_ expensesRef: FIRDatabaseReference) {
        expensesRef.observeSingleEvent(of: .value, with: { (expenseSnapshot) in
            if expenseSnapshot.exists() {
                self.lastExpense = GroupExpense.expenseFromResults(self.group.lastExpense, results: expenseSnapshot.value! as! NSDictionary)
                self.prepareLastExpenseView()
            }
        })
    }
    
    fileprivate func getGroupData() {
        
        if let groupRef = firebaseRef.child("groups/\(groupId)") as FIRDatabaseReference? {
            groupRef.observeSingleEvent(of: .value, with: { (groupSnapshot) in
                if groupSnapshot.exists() {
                    self.group = Group.groupFromFirebase(self.groupId, results: groupSnapshot.value! as! NSDictionary)
                    self.prepareGroupHeaderView()
                    self.groupMembers.removeAll()
                    for member in self.group.members {
                        var user = User()
                        if let userRef = self.firebaseRef.child("users/\(member)") as FIRDatabaseReference? {
                            userRef.observeSingleEvent(of: .value, with: { (userSnapshot) in
                                user = User.userFromFirebase(userSnapshot.value! as! NSDictionary)
                                self.groupMembers.append(user)
                                self.prepareGroupMembersView()
                            })
                        }
                    }
                    if let expenseRef = self.firebaseRef.child("groupExpenses/\(self.groupId)/\(self.group.lastExpense)") as FIRDatabaseReference? {
                        self.prepareLastExpense(expenseRef)
                    }
                    if let expenseRef = self.firebaseRef.child("groupExpenses/\(self.groupId)") as FIRDatabaseReference? {
                        
                        self.prepareExpenseCategories(expenseRef)
                    }
                }
            })
        }

        if let groupExpensesTotalsRef = firebaseRef.child("groupExpenses/\(groupId)/totals") as FIRDatabaseReference? {
        
            groupExpensesTotalsRef.observeSingleEvent(of: .value, with: { (expenseTotals) in
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupMembers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memberCell", for: indexPath) as! AlphaCollectionCell
        cell.backgroundColor = MaterialColor.white
        
        cell.nameLabel.textColor = MaterialColor.black
        
        
        let groupMember = groupMembers[(indexPath as NSIndexPath).row]
        
        cell.imageView.image = UIImage(named: "default_user")

        
        if let photoURL = groupMember.photoURL as String? {
            if photoURL != "" {
                cell.imageView.imageURL = URL(string: photoURL)
            } 
        }
        
        
        cell.nameLabel.text = groupMember.name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
        
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10.0
    }
    
    // MARK: - Buttons
    
    @IBAction func seeAllGroupExpenses(_ sender: AnyObject) {
        if let expensesListViewController = self.storyboard?.instantiateViewController(withIdentifier: "expensesListViewController") as? ExpensesListViewController {
            expensesListViewController.expenseType = .group
            expensesListViewController.groupExpensesRef = self.firebaseRef.child("groupExpenses/\(groupId)")
            expensesListViewController.groupName = self.group.name
            self.navigationController?.pushViewController(expensesListViewController, animated: true)
        }
    }
    
    
    @IBAction func addGroupExpense(_ sender: AnyObject) {
        //to do
        if let addExpenseVC = self.storyboard?.instantiateViewController(withIdentifier: "addExpenseController") as? AddExpenseController {

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
 

    // MARK: - ChartView
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: Highlight) {
        print(entry)
        print(dataSetIndex)
        print(highlight)
    }
    
    fileprivate func prepareChartView() {
        
        
        
        //groupChartView.setExtraOffsets(left: 5, top: 5, right: 5, bottom: 5)
        groupChartView.delegate = self
        groupChartView.highlightValues(nil)
        
        
        
        
        groupChartView.descriptionText = ""
        groupChartView.drawHoleEnabled = false
        groupChartView.usePercentValuesEnabled = true
        groupChartView.drawSlicesUnderHoleEnabled = true
        groupChartView.legend.position = .rightOfChartCenter
        
        groupChartView.legend.form = .square
        groupChartView.drawSliceTextEnabled = false
        
        groupChartView.alpha = 0
    }
    
    fileprivate func prepareChartViewData(_ chartData: [String: Float]) {
        
    }
    
    
    func updateGraphData() {
        
        let (_, currmon, currweek) = calculateDateValues()
        
        
        if self.expenseCategories.count > 0 {
            for expenseCategrory in self.expenseCategories {
                if let expenseCategoryDetail = expenseCategrory.1 as [String: Float]? {
                    
                    if let thisExpTotal = expenseCategoryDetail["total"] as Float? {
                        self.expenseCategoriesTotal[expenseCategrory.0] = thisExpTotal
                    } else {
                        self.expenseCategoriesTotal[expenseCategrory.0] = 0.0
                    }
                    if let thisExpTotal = expenseCategoryDetail[currmon] as Float? {
                        self.expenseCategoriesThisMonth[expenseCategrory.0] = thisExpTotal
                    } else {
                        self.expenseCategoriesThisMonth[expenseCategrory.0] = 0.0
                    }
                    if let thisExpTotal = expenseCategoryDetail[currweek] as Float? {
                        self.expenseCategoriesThisWeek[expenseCategrory.0] = thisExpTotal
                    } else {
                        self.expenseCategoriesThisWeek[expenseCategrory.0] = 0.0
                    }
                }
            }
        }
        
        switch self.segmentButtonState {
        case .total:
            prepareChartViewData(self.expenseCategoriesTotal)
        case .thisMonth:
            prepareChartViewData(self.expenseCategoriesThisMonth)
        case .thisWeek:
            prepareChartViewData(self.expenseCategoriesThisWeek)
        }
        
        
    }

}
