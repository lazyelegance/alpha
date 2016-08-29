//
//  GroupMainViewController.swift
//  alpha
//
//  Created by Ezra Bathini on 29/07/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import Material
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
    
    private func prepareExpenseCategories(expensesRef: FIRDatabaseReference) {
        self.expenseCategories.removeAll()
        expensesRef.child("categories").observeEventType(.Value, withBlock: { (categoriessnapshot) in
            if categoriessnapshot.exists() {
                self.expenseCategories = GroupExpense.categoriesFromResults(categoriessnapshot.value! as! NSDictionary)
                self.updateGraphData()
            } else {
                
            }
        })
    }
    
    private func prepareLastExpense(expensesRef: FIRDatabaseReference) {
        expensesRef.observeSingleEventOfType(.Value, withBlock: { (expenseSnapshot) in
            if expenseSnapshot.exists() {
                self.lastExpense = GroupExpense.expenseFromResults(self.group.lastExpense, results: expenseSnapshot.value! as! NSDictionary)
                self.prepareLastExpenseView()
            }
        })
    }
    
    private func getGroupData() {
        
        if let groupRef = firebaseRef.child("groups/\(groupId)") as FIRDatabaseReference? {
            groupRef.observeSingleEventOfType(.Value, withBlock: { (groupSnapshot) in
                if groupSnapshot.exists() {
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
                        self.prepareLastExpense(expenseRef)
                    }
                    if let expenseRef = self.firebaseRef.child("groupExpenses/\(self.groupId)") as FIRDatabaseReference? {
                        
                        self.prepareExpenseCategories(expenseRef)
                    }
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
 

    // MARK: - ChartView
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        print(entry)
        print(dataSetIndex)
        print(highlight)
    }
    
    private func prepareChartView() {
        
        
        
        //groupChartView.setExtraOffsets(left: 5, top: 5, right: 5, bottom: 5)
        groupChartView.delegate = self
        groupChartView.highlightValues(nil)
        
        
        
        
        groupChartView.descriptionText = ""
        groupChartView.drawHoleEnabled = false
        groupChartView.usePercentValuesEnabled = true
        groupChartView.drawSlicesUnderHoleEnabled = true
        groupChartView.legend.position = .RightOfChartCenter
        
        groupChartView.legend.form = .Square
        groupChartView.drawSliceTextEnabled = false
        
        groupChartView.alpha = 0
    }
    
    private func prepareChartViewData(chartData: [String: Float]) {
        if chartData.count > 0 {
            
            xVals.removeAll()
            yVals.removeAll()
            
            var i = 0
            
            for expense in chartData {
                
                if expense.1 > 0 {
                    let entry = BarChartDataEntry(value: Double(expense.1), xIndex: i)
                    yVals.append(entry)
                    i = i + 1
                    xVals.append(expense.0)
                }
                
            }
            
            let dataSet = PieChartDataSet(yVals: yVals, label: "")
            
            dataSet.sliceSpace = 2.0
            
            let colors = [MaterialColor.red.darken1,MaterialColor.blue.darken1,MaterialColor.green.darken1,MaterialColor.orange.darken1,MaterialColor.amber.darken1,MaterialColor.indigo.darken1,MaterialColor.purple.darken1,MaterialColor.yellow.darken1]
            
            
            dataSet.colors = colors.sort({_, _ in arc4random() % 2 == 0})
            
            //dataSet.colors = ChartColorTemplates.liberty()
            let data = PieChartData(xVals: xVals, dataSets: [dataSet])
            
            let pFormatter = NSNumberFormatter()
            pFormatter.numberStyle = .PercentStyle
            pFormatter.maximumFractionDigits = 1
            pFormatter.percentSymbol = " %"
            pFormatter.multiplier = 1
            data.setValueFormatter(pFormatter)
            data.setValueFont(UIFont.systemFontOfSize(10))
            data.setValueTextColor(MaterialColor.white)
            
            groupChartView.alpha = 1
            groupChartView.data = data
            groupChartView.animate(yAxisDuration: 0.5, easingOption: ChartEasingOption.EaseOutCirc)
            
            
        }
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
