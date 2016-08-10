//
//  ViewController.swift
//  alpha
//
//  Created by Ezra Bathini on 15/07/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import Material
import Charts





enum SegementButtonState {
    case total
    case thisMonth
    case thisWeek
    
    func titleString() -> String {
        switch self {
        case .total:
            return "Total".uppercaseString
        case .thisMonth:
            return "This Month".uppercaseString
        case .thisWeek:
            return "This Week".uppercaseString
        }
    }
    
    func nextState() -> SegementButtonState {
        switch self {
        case .total:
            return .thisMonth
        case .thisMonth:
            return .thisWeek
        case .thisWeek:
            return .total
        }
    }
    
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ChartViewDelegate {
    
    private var fabMenu: Menu!
    private var flatMenu: Menu!
    private var flashMenu: Menu!
    
    let spacing: CGFloat = 16
    let diameter: CGFloat = 56
    let height: CGFloat = 36
    
    let btn1: FlatButton = FlatButton()
    let btn2: FlatButton = FlatButton()
    let btn3: FlatButton = FlatButton()
    
    var expenses = [Expense]()
    var totalSpent: Float = 0.0
    var thisMonthSpent: Float = 0.0
    var thisWeekSpent: Float = 0.0
    var totals = [String : Float]()
    
    var expenseCategories = [String: [String: Float]]()
    var expenseCategoriesTotal = [String: Float]()
    var expenseCategoriesThisMonth = [String: Float]()
    var expenseCategoriesThisWeek = [String: Float]()
    var yVals = [BarChartDataEntry]()
    var xVals = [String]()
    
    var userGroups = [Group]()
    var groupExpenses = [GroupExpense]()

    
    
    @IBOutlet weak var headerView: MaterialView!

    @IBOutlet weak var userExpensesView: MaterialView!
    @IBOutlet weak var userGroupsView: MaterialView!
    
    
    @IBOutlet weak var userChartView: PieChartView!
    @IBOutlet weak var groupsTableView: UITableView!
    
    
    
    @IBOutlet weak var profileImageView: AsyncImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var segmentButton: FlatButton!
    
    @IBOutlet weak var spentHeaderLabel: UILabel!
    @IBOutlet weak var mainBalance: UILabel!
    
    @IBOutlet weak var showAllExpensesUserBtn: FlatButton!
    
    @IBOutlet weak var addNewExpenseUserBtn: FlatButton!
    
    var user = User()
    var group = Group()
    var groupMembers = [User]()
    
    var alphaRef = FIRDatabaseReference.init()
    
    var segmentButtonState = SegementButtonState.total
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.hidden = true
        
        //prepareMenu()
        alphaRef = FIRDatabase.database().reference()
        
        
        
        


    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        if (FIRAuth.auth()?.currentUser) != nil {
            prepareView()
            prepareUIElements()
            prepareExpenseData()
            prepareChartView()
        } else {
            showLoginScreen()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Prepare View
    
    private func prepareView() {
        view.backgroundColor = MaterialColor.indigo.base

        
        headerView.backgroundColor = MaterialColor.white
        userExpensesView.backgroundColor = MaterialColor.white
        userGroupsView.backgroundColor = MaterialColor.white
    }
    
    // MARK: - ChartView
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        print(entry)
        print(dataSetIndex)
        print(highlight)
    }
    
    private func prepareChartView() {
        
        userChartView.backgroundColor = userExpensesView.backgroundColor
        
        //userChartView.setExtraOffsets(left: 5, top: 5, right: 5, bottom: 5)
        userChartView.delegate = self
        userChartView.highlightValues(nil)
        //        chartView.holeRadiusPercent = 0.1
        //        chartView.transparentCircleRadiusPercent = 1
        
        
        userChartView.descriptionText = ""
        userChartView.drawHoleEnabled = false
        userChartView.usePercentValuesEnabled = true
        userChartView.drawSlicesUnderHoleEnabled = true
        userChartView.legend.position = .RightOfChartCenter
        
        userChartView.legend.form = .Square
        userChartView.drawSliceTextEnabled = false
        userChartView.alpha = 0
    }
    
    private func prepareChartViewData(chartData: [String: Float]) {
        if chartData.count > 0 {
            
            xVals.removeAll()
            yVals.removeAll()
            
            var i = 0
            
            for expense in chartData {
                let entry = BarChartDataEntry(value: Double(expense.1), xIndex: i)
                yVals.append(entry)
                i = i + 1
                xVals.append(expense.0)
            }
            
            print("yvals == \(yVals)")
            print("xvals == \(xVals)")
            
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
            
            userChartView.alpha = 1
            userChartView.data = data
            userChartView.animate(yAxisDuration: 0.5, easingOption: ChartEasingOption.EaseOutCirc)

        }
    }
    
    
    private func prepareUIElements() {
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = 5
        spentHeaderLabel.text = "Loading"
        spentHeaderLabel.font = UIFont.italicSystemFontOfSize(15)
        spentHeaderLabel.textColor = MaterialColor.grey.lighten1
        
        
        segmentButton.alpha = 0
        mainBalance.alpha = 0
        showAllExpensesUserBtn.alpha = 0
        addNewExpenseUserBtn.alpha = 0
        
        
        headerView.alpha = 0
        userGroupsView.alpha = 0
        
//        userExpensesView.backgroundColor = self.view.backgroundColor
        
        
        if user.userId != "1" {
            
            spentHeaderLabel.text = "You have spent"
            spentHeaderLabel.font = RobotoFont.regularWithSize(14)
            spentHeaderLabel.textColor = MaterialColor.black

            self.messageLabel.text = "Welcome."
            self.nameLabel.text = self.user.name
//            if let photoURLString = self.user.photoURL as String? {
//                self.profileImageView.imageURL = NSURL(string: photoURLString)
//            }
            headerView.alpha = 1
        }
        
        segmentButton.tag = 110
        segmentButton.addTarget(self, action: #selector(self.updateSpentField(_:)), forControlEvents: .TouchUpInside)
        

    }
    
    private func prepareMenu() {
        btn1.addTarget(self, action: #selector(ViewController.handleFlatMenu), forControlEvents: .TouchUpInside)
        btn1.setTitleColor(MaterialColor.blue.accent1, forState: .Normal)
        btn1.titleLabel?.font = RobotoFont.regularWithSize(12)
        btn1.backgroundColor = MaterialColor.white
        btn1.pulseColor = MaterialColor.white
        
        btn1.setTitle("Menu".uppercaseString, forState: .Normal)
        
        
        //btn1.setImage(MaterialIcon.menu, forState: .Normal)
        
        view.addSubview(btn1)
        
        
        btn2.setTitleColor(MaterialColor.white, forState: .Normal)
        btn2.titleLabel?.font = RobotoFont.boldWithSize(12)
        //btn2.borderColor = MaterialColor.white
        btn2.pulseColor = MaterialColor.blue.accent3
        //btn2.borderWidth = 1
//        btn2.setTitle("Add Expense".uppercaseString, forState: .Normal)
//        btn2.addTarget(self, action: #selector(self.toAddExpenseCycle), forControlEvents: .TouchUpInside)
        view.addSubview(btn2)
        
        
        btn3.setTitleColor(MaterialColor.white, forState: .Normal)
        btn3.titleLabel?.font = RobotoFont.boldWithSize(12)
        //        btn3.borderColor = MaterialColor.blueGrey.lighten1
        btn3.pulseColor = MaterialColor.blue.accent3
        //        btn3.borderWidth = 1
        btn3.setTitle("See Expenses".uppercaseString, forState: .Normal)
//        btn3.addTarget(self, action: #selector(self.toListExpenses), forControlEvents: .TouchUpInside)
        view.addSubview(btn3)
        
        let btn4: FlatButton = FlatButton()
        btn4.setTitleColor(MaterialColor.blue.accent3, forState: .Normal)
        btn4.borderColor = MaterialColor.blue.accent3
        btn4.pulseColor = MaterialColor.blue.accent3
        btn4.borderWidth = 1
        btn4.setTitle("Item", forState: .Normal)
        btn4.addTarget(self, action: #selector(self.toUserGroups), forControlEvents: .TouchUpInside)
        view.addSubview(btn4)
        
        // Initialize the menu and setup the configuration options.
        
        flatMenu = Menu(origin: CGPointMake(view.bounds.width/2 - 60, view.bounds.height - height - spacing))
        flatMenu.direction = .Up
        flatMenu.spacing = 8
        flatMenu.itemSize = CGSizeMake(120, height)
        flatMenu.views = [btn1, btn2, btn3, btn4]
    }
    
    // MARK: - Query Firebase
    
    private func prepareExpenseData() {
        if let currentUser = FIRAuth.auth()?.currentUser {

            
            if let userRef = alphaRef.child("users/\(currentUser.uid)") as FIRDatabaseReference? {
                
                userRef.observeEventType(.Value, withBlock: { (snapshot) in
                    if snapshot.exists() {
                        self.user = User.userFromFirebase(snapshot.value! as! NSDictionary)
                        self.prepareUIElements()
                        
                        self.userGroups.removeAll()
                        for groupId in self.user.groups {
                            if let groupRef = self.alphaRef.child("groups/\(groupId)") as FIRDatabaseReference? {
                                groupRef.observeSingleEventOfType(.Value, withBlock: { (groupSnapshot) in
                                    self.userGroups.append(Group.groupFromFirebase(groupId, results: groupSnapshot.value! as! NSDictionary))
                                    self.groupsTableView.reloadData()
                                    self.userGroupsView.alpha = 1
                                })
                            }
                        }
                        
                        
                        
                        if let userId = self.user.userId as String? {
                            if let expensesRef = self.alphaRef.child("expenses/\(userId)") as FIRDatabaseReference? {
                                
                                self.totals.removeAll()
                                expensesRef.child("totals").observeEventType(.Value, withBlock: { (totalssnapshot) in
                                    if totalssnapshot.exists() {
                                        self.totals = Expense.totalsFromResults(totalssnapshot.value! as! NSDictionary)
                                        self.updateSpentField(self)
                                    } else {
                                        self.spentHeaderLabel.text = "You have not added any expenses yet. Click below to start"
                                        self.addNewExpenseUserBtn.setTitle("ADD YOUR FIRST EXPENSE", forState: .Normal)
                                        self.addNewExpenseUserBtn.alpha = 1
//                                        self.userExpensesView.backgroundColor = MaterialColor.white
                                    }
                                })
                                
                                expensesRef.child("categories").observeEventType(.Value, withBlock: { (categoriessnapshot) in
                                    if categoriessnapshot.exists() {
                                        //print(categoriessnapshot.value!)
                                        self.expenseCategories = Expense.categoriesFromResults(categoriessnapshot.value! as! NSDictionary)
                                        self.updateGraphData()
                                    } else {
                                        
                                    }
                                })
                                
                                
                                
                            }
                        }
                        
                        
                        if let groupId = self.user.defaultGroupId as String? {
                            
                            
                            if let groupRef = self.alphaRef.child("groups/\(groupId)") as FIRDatabaseReference? {
                                groupRef.observeSingleEventOfType(.Value, withBlock: { (groupSnapshot) in
                                    self.group = Group.groupFromFirebase(self.user.defaultGroupId, results: groupSnapshot.value! as! NSDictionary)
                                    for member in self.group.members {
                                        if let memberRef = self.alphaRef.child("users/\(member)") as FIRDatabaseReference? {
                                            memberRef.observeEventType(.Value, withBlock: { (memberSnapshot) in
                                                self.groupMembers.append(User.userFromFirebase(memberSnapshot.value! as! NSDictionary))
                                            })
                                        }
                                    }
                                })
                            }
                        }
                    }
                })
            }
        }
    }
    
    
    private func showLoginScreen() {
        if let loginViewController = self.storyboard!.instantiateViewControllerWithIdentifier("loginViewController") as? LoginViewController {
            self.navigationController?.pushViewController(loginViewController, animated: true)
        } else {
            print("cannot instantiate login")
        }
    }
    
    
    
    
    
    // MARK: - Button Menus
    
    func handleFlatMenu() {
        // Only trigger open and close animations when enabled.
        if flatMenu.enabled {
            if flatMenu.opened {
                flatMenu.close()
            } else {
                flatMenu.open()
            }
        }
    }
    
    
    func calculateDateValues() -> (String, String) {
        let timzoneSeconds = NSTimeZone.localTimeZone().secondsFromGMT
        
        let currDate = NSDate().dateByAddingTimeInterval(Double(timzoneSeconds))
        
        let formatter_mon = NSDateFormatter()
        formatter_mon.dateFormat = "MM_yyyy"
        let currmon = "m_" + formatter_mon.stringFromDate(currDate)
        
        
        
        let formatter_week = NSDateFormatter()
        formatter_week.dateFormat = "w_yyyy"
        let currweek = "w_" + formatter_week.stringFromDate(currDate)
        
        return (currmon, currweek)
    }
    
    func updateGraphData() {
        
        let (currmon, currweek) = self.calculateDateValues()
        
        
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
    
    func updateSpentField(sender: AnyObject) {
        
        let (currmon, currweek) = self.calculateDateValues()
        
        if self.totals.count > 0 {
            if self.totals["total"] != nil {
                self.totalSpent = self.totals["total"] as Float!
            }
            
            if self.totals[currmon] != nil {
                self.thisMonthSpent = self.totals[currmon] as Float!
            }
            
            if self.totals[currweek] != nil {
                self.thisWeekSpent = self.totals[currweek] as Float!
            }
            
            if sender.tag != nil && sender.tag == 110 {
                self.segmentButtonState = self.segmentButtonState.nextState()
            }
            

        }
        
        
        
        self.segmentButton.setTitle(self.segmentButtonState.titleString(), forState: .Normal)
        switch self.segmentButtonState {
        case .total:
            self.mainBalance.text = "\(self.totalSpent) $"
        case .thisMonth:
            self.mainBalance.text = "\(self.thisMonthSpent) $"
        case .thisWeek:
            self.mainBalance.text = "\(self.thisWeekSpent) $"
        }
        

        self.showAllExpensesUserBtn.alpha = 1
        self.addNewExpenseUserBtn.alpha = 1
        self.segmentButton.alpha = 1
        self.mainBalance.alpha = 1
        
        
        self.updateGraphData()

    }
    
    
    func toUserGroups() {
        if let groupMainViewController = self.storyboard?.instantiateViewControllerWithIdentifier("groupMainViewController") as? GroupMainViewController {
            groupMainViewController.firebaseRef = alphaRef
            groupMainViewController.currentUser = user
            groupMainViewController.groupId = user.defaultGroupId
            self.navigationController?.pushViewController(groupMainViewController, animated: true)
        }
    
        
    }
    
    
    @IBAction func addNewExpense_User(sender: AnyObject) {
        if let addExpenseVC = self.storyboard?.instantiateViewControllerWithIdentifier("addExpenseController") as? AddExpenseController {
            addExpenseVC.currentStep = AddExpenseStep.description
            addExpenseVC.expenseType = ExpenseType.user
            
            
            var newExpense = Expense()
            
            if let userId = self.user.userId as String? {
                newExpense.firebaseDBRef = alphaRef.child("expenses/\(userId)")
            }
            
            addExpenseVC.newExpense = newExpense
            self.navigationController?.pushViewController(addExpenseVC, animated: true)
        }
    }
    
   
    @IBAction func showAllExpenses_User(sender: AnyObject) {
        if let userId = self.user.userId as String? {
            if let expensesListViewController = self.storyboard?.instantiateViewControllerWithIdentifier("expensesListViewController") as? ExpensesListViewController {
                expensesListViewController.expenseType = .user
                expensesListViewController.expensesRef = self.alphaRef.child("expenses/\(userId)")
                expensesListViewController.userName = self.user.name
                self.navigationController?.pushViewController(expensesListViewController, animated: true)
            }
        }
        
    }
    

//    func toListExpenses() {
//        if let userId = self.user.userId as String? {
//            if let expensesListViewController = self.storyboard?.instantiateViewControllerWithIdentifier("expensesListViewController") as? ExpensesListViewController {
//                expensesListViewController.expenseType = .user
//                expensesListViewController.expensesRef = self.alphaRef.child("expenses/\(userId)")
//                self.navigationController?.pushViewController(expensesListViewController, animated: true)
//            }
//        }
//        
//    }
//    
//    func toAddExpenseCycle() {
//        if let addExpenseVC = self.storyboard?.instantiateViewControllerWithIdentifier("addExpenseController") as? AddExpenseController {
//            addExpenseVC.currentStep = AddExpenseStep.description
//            addExpenseVC.expenseType = ExpenseType.user
//            
//            
//            var newExpense = Expense()
//            
//            if let userId = self.user.userId as String? {
//                newExpense.firebaseDBRef = alphaRef.child("expenses/\(userId)")
//            }
//            
//            addExpenseVC.newExpense = newExpense
//            self.navigationController?.pushViewController(addExpenseVC, animated: true)
//        }
//    }
    
    
    

    
    // MARK: - TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userGroups.count;
    }
    
    /// Returns the number of sections.
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    /// Prepares the cells within the tableView.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: MaterialTableViewCell = MaterialTableViewCell(style: .Subtitle, reuseIdentifier: "groupCell")
        
        let userGroup = userGroups[indexPath.row]
        cell.selectionStyle = .None
        cell.textLabel!.text = userGroup.name
        cell.textLabel!.font = RobotoFont.regular
        
        cell.detailTextLabel?.text = "Select to see more details"
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.lineBreakMode = .ByWordWrapping
        
        cell.detailTextLabel!.font = RobotoFont.regular
        cell.detailTextLabel!.textColor = MaterialColor.grey.darken1
        cell.imageView?.image = UIImage(named: "default_group")

        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if userGroups.count > 1 {
            return 50
        }
        return 60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let groupMainViewController = self.storyboard?.instantiateViewControllerWithIdentifier("groupMainViewController") as? GroupMainViewController {
            groupMainViewController.firebaseRef = alphaRef
            groupMainViewController.currentUser = user
            groupMainViewController.groupId = userGroups[indexPath.row].groupId
            self.navigationController?.pushViewController(groupMainViewController, animated: true)
        }
        
    }


}

