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
import Charts







class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ChartViewDelegate {
    

    
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
    
    var categories = [Category]()
    
    var expenseCategories = [String: [String: Float]]()
    var expenseCategoriesTotal = [String: Float]()
    var expenseCategoriesThisMonth = [String: Float]()
    var expenseCategoriesThisWeek = [String: Float]()
    var yVals = [BarChartDataEntry]()
    var xVals = [String]()
    
    var userGroups = [Group]()
    var groupExpenses = [GroupExpense]()

    @IBOutlet weak var alphaLogo: AsyncImageView!
    @IBOutlet weak var settingButton: FlatButton!
    
    
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
    
    var segmentButtonState = SegmentButtonState.total
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        
        //prepareMenu()
        alphaRef = FIRDatabase.database().reference()

    }

    
    override func viewWillAppear(_ animated: Bool) {
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
    
    fileprivate func prepareView() {
        view.backgroundColor = MaterialColor.indigo.base

        
        headerView.backgroundColor = MaterialColor.white
        userExpensesView.backgroundColor = MaterialColor.white
        userGroupsView.backgroundColor = MaterialColor.white
    }
    
    // MARK: - ChartView
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: Highlight) {
        
        
//        var chartdata = [String]()
//        chartdata.removeAll()
//        switch self.segmentButtonState {
//        case .total:
//            for expense in self.expenseCategoriesTotal {
//                chartdata.append(expense.0)
//            }
//        case .thisMonth:
//            for expense in self.expenseCategoriesThisMonth {
//                chartdata.append(expense.0)
//            }
//        case .thisWeek:
//            for expense in self.expenseCategoriesThisWeek {
//                chartdata.append(expense.0)
//            }
//        }
//        
//        if let userId = self.user.userId as String? {
//            if let expensesListViewController = self.storyboard?.instantiateViewController(withIdentifier: "expensesListViewController") as? ExpensesListViewController {
//                expensesListViewController.expenseType = .user
//                expensesListViewController.expensesRef = self.alphaRef.child("expenses/\(userId)")
//                expensesListViewController.userName = self.user.name
//                expensesListViewController.showFilteredResults = true
//                expensesListViewController.selectedCategory = chartdata[entry.index]
//                self.navigationController?.pushViewController(expensesListViewController, animated: true)
//            }
//        }
    }
    
    fileprivate func prepareChartView() {
        
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
        userChartView.legend.position = .rightOfChartCenter
        
        userChartView.legend.form = .square
        userChartView.drawSliceTextEnabled = false
        userChartView.alpha = 0
    }
    
    fileprivate func prepareChartViewData(_ chartData: [String: Float]) {
        if chartData.count > 0 {
            
            var chartDataFinal = [ChartDataEntry]()
            chartDataFinal.removeAll()
            for expense in chartData {
                
                if expense.1 > 0 {
                    
                    
                    let entry = PieChartDataEntry(value: Double(expense.value), label: expense.key)
                    //                BarChartDataEntry(value: Double(expense.value), xIndex: i)
                    chartDataFinal.append(entry)
                }
                
            }
            
            let dataSet  = PieChartDataSet(values: chartDataFinal, label: "expenses")
            
            dataSet.sliceSpace = 2.0
            
            let colors = [MaterialColor.red.darken1,MaterialColor.blue.darken1,MaterialColor.green.darken1,MaterialColor.orange.darken1,MaterialColor.amber.darken1,MaterialColor.indigo.darken1,MaterialColor.purple.darken1,MaterialColor.yellow.darken1]
            
            
            dataSet.colors = colors.sorted(by: {_, _ in arc4random() % 2 == 0})
            
            //dataSet.colors = ChartColorTemplates.liberty()
            let data = PieChartData(dataSet: dataSet)
            
            let pFormatter = NumberFormatter()
            pFormatter.numberStyle = .percent
            pFormatter.maximumFractionDigits = 1
            pFormatter.percentSymbol = " %"
            pFormatter.multiplier = 1
            //        data.setValueFormatter(<#T##formatter: IValueFormatter?##IValueFormatter?#>)
            //        data.setValueFormatter(pFormatter)
            data.setValueFont(UIFont.systemFont(ofSize: 10))
            data.setValueTextColor(MaterialColor.white)
            
            userChartView.alpha = 1
            userChartView.data = data
            userChartView.animate(yAxisDuration: 0.5, easingOption: ChartEasingOption.easeOutCirc)
            

        }
    }
    
    
    fileprivate func prepareUIElements() {
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = 5
        spentHeaderLabel.text = "Loading"
        spentHeaderLabel.font = UIFont.italicSystemFont(ofSize: 15)
        spentHeaderLabel.textColor = MaterialColor.grey.lighten1
        
        
        segmentButton.alpha = 0
        mainBalance.alpha = 0
        showAllExpensesUserBtn.alpha = 0
        addNewExpenseUserBtn.alpha = 0
        
        userExpensesView.alpha = 0
        headerView.alpha = 0
        userGroupsView.alpha = 0
        
        if user.userId != "1" {
            
            spentHeaderLabel.text = "You have spent"
            spentHeaderLabel.font = UIFont.systemFont(ofSize: 14)// RobotoFont.regularWithSize(14)
            spentHeaderLabel.textColor = MaterialColor.black

            self.messageLabel.text = "Welcome."
            self.nameLabel.text = self.user.name
            
            if user.photoURL != "" {
                profileImageView.imageURL = URL(string: user.photoURL)
            }
            headerView.alpha = 1
        }
        
        segmentButton.tag = 110
        segmentButton.addTarget(self, action: #selector(self.updateSpentField(_:)), for: .touchUpInside)
        

    }
    
    
    // MARK: - Query Firebase
    
    fileprivate func prepareUserGroupsData(_ groups: [String]) {
        self.userGroups.removeAll()
        for groupId in groups {
            if let groupRef = self.alphaRef.child("groups/\(groupId)") as FIRDatabaseReference? {
                groupRef.observeSingleEvent(of: .value, with: { (groupSnapshot) in
                    if groupSnapshot.exists() {
                        self.userGroups.append(Group.groupFromFirebase(groupId, results: groupSnapshot.value! as! NSDictionary))
                        self.groupsTableView.reloadData()
                        self.userGroupsView.alpha = 1
                    } else {
                        //
                    }
                })
            }
        }
    }
    
    fileprivate func prepareExpenseTotals(_ expensesRef: FIRDatabaseReference) {
        self.totals.removeAll()
        expensesRef.child("totals").observe(.value, with: { (totalssnapshot) in
            if totalssnapshot.exists() {
                self.totals = Expense.totalsFromResults(totalssnapshot.value! as! NSDictionary)
                self.updateSpentField(self)
                self.userExpensesView.alpha = 1
                
            } else {
                self.showOnboardingScreen()
            }
        })
    }
    
    fileprivate func prepareExpenseCategories(_ expensesRef: FIRDatabaseReference) {
        expensesRef.child("categories").observe(.value, with: { (categoriessnapshot) in
            if categoriessnapshot.exists() {
                self.categories = Category.categoriesFromResults(categoriessnapshot.value! as! NSDictionary)
                self.updateGraphData()
            } else {
                // TO DO
            }
        })
    }
    
    
    fileprivate func prepareExpenseData() {
        if let currentUser = FIRAuth.auth()?.currentUser {

            
            if let userRef = alphaRef.child("users/\(currentUser.uid)") as FIRDatabaseReference? {
                userRef.observe(.value, with: { (snapshot) in
                    if snapshot.exists() {
                        self.user = User.userFromFirebase(snapshot.value! as! NSDictionary)

                        self.prepareUIElements()
                        
//                        self.prepareUserGroupsData(self.user.groups) ---------------> Turn Off Groups?
                        
                        if let userId = self.user.userId as String? {
                            if let expensesRef = self.alphaRef.child("expenses/\(userId)") as FIRDatabaseReference? {
                                self.prepareExpenseTotals(expensesRef)
                                self.prepareExpenseCategories(expensesRef)
                            }
                        }
                    } else {
                        self.showOnboardingScreen()
                    }
                })
            } else {
                showOnboardingScreen()
            }
        }
    }
    
    // MARK: - Navigate
    
    fileprivate func showLoginScreen() {
        if let loginViewController = self.storyboard!.instantiateViewController(withIdentifier: "loginViewController") as? LoginViewController {
            loginViewController.alphaRef = self.alphaRef
            self.navigationController?.pushViewController(loginViewController, animated: true)
        } else {
            print("cannot instantiate login")
        }
    }
    
    fileprivate func showOnboardingScreen() {

        
        if let username = FIRAuth.auth()?.currentUser?.displayName {
            self.messageLabel.text = "Welcome."
            self.nameLabel.text = username
            headerView.alpha = 1
            
            self.segmentButton.alpha = 0
            self.showAllExpensesUserBtn.alpha = 0
            self.mainBalance.alpha = 0
            
            self.userExpensesView.alpha = 1
            self.spentHeaderLabel.text = "You have not added any expenses yet. Click below to start"
            self.addNewExpenseUserBtn.setTitle("ADD YOUR FIRST EXPENSE", for: .normal)
            self.addNewExpenseUserBtn.alpha = 1

        }
        
        
    }
    
    
    @IBAction func showSettingsScreen(_ sender: AnyObject) {
        if let userSettingsViewController = self.storyboard?.instantiateViewController(withIdentifier: "userSettingsViewController") as? UserSettingsViewController {
            userSettingsViewController.user = user
            userSettingsViewController.expensesRef = alphaRef.child("expenses/\(user.userId)")
            self.navigationController?.pushViewController(userSettingsViewController, animated: true)
        }
    }
    
    
    
    // MARK: - Button Menus
    


    
    func updateGraphData() {
        if self.categories.count > 0 {
            
            switch self.segmentButtonState {
            case .total:
                categories.sort(by: { (a, b) -> Bool in return (a.counter > b.counter) })
            case .thisMonth:
                categories.sort(by: { (a, b) -> Bool in return (a.thisMonthCounter > b.thisMonthCounter) })
            case .thisWeek:
                categories.sort(by: { (a, b) -> Bool in return (a.thisWeekCounter > b.thisWeekCounter) })
            }
            
            
            var i = 0
            
            for category in categories {
                self.expenseCategoriesTotal[category.name] = category.total
                self.expenseCategoriesThisMonth[category.name] = category.thisMonth
                self.expenseCategoriesThisWeek[category.name] = category.thisWeek
                
                i = i + 1
                if i > 2 {
                    break
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
    
    func updateSpentField(_ sender: AnyObject) {
        
        let (_, currmon, currweek) = calculateDateValues()
        
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
        
        
        self.segmentButton.setTitle(self.segmentButtonState.titleString(), for: .normal)
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
        if let groupMainViewController = self.storyboard?.instantiateViewController(withIdentifier: "groupMainViewController") as? GroupMainViewController {
            groupMainViewController.firebaseRef = alphaRef
            groupMainViewController.currentUser = user
            groupMainViewController.groupId = user.defaultGroupId
            self.navigationController?.pushViewController(groupMainViewController, animated: true)
        }
    
        
    }
    
    
    @IBAction func addNewExpense_User(_ sender: AnyObject) {
        if let addExpenseVC = self.storyboard?.instantiateViewController(withIdentifier: "addExpenseController") as? AddExpenseController {
            addExpenseVC.currentStep = AddExpenseStep.description
            addExpenseVC.expenseType = ExpenseType.user
            
            
            var newExpense = Expense()
            
            if let userId = self.user.userId as String? {
                newExpense.firebaseDBRef = alphaRef.child("expenses/\(userId)")
            }
            
            addExpenseVC.newExpense = newExpense
            addExpenseVC.categories = categories
            
            self.navigationController?.pushViewController(addExpenseVC, animated: true)
        }
    }
    
   
    @IBAction func showAllExpenses_User(_ sender: AnyObject) {
        if let userId = self.user.userId as String? {
            if let expensesListViewController = self.storyboard?.instantiateViewController(withIdentifier: "expensesListViewController") as? ExpensesListViewController {
                expensesListViewController.expenseType = .user
                expensesListViewController.expensesRef = self.alphaRef.child("expenses/\(userId)")
                expensesListViewController.userName = self.user.name
                expensesListViewController.categories = categories
                self.navigationController?.pushViewController(expensesListViewController, animated: true)
            }
        }
        
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userGroups.count;
    }
    
    /// Returns the number of sections.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// Prepares the cells within the tableView.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MaterialTableViewCell = MaterialTableViewCell(style: .subtitle, reuseIdentifier: "groupCell")
        
        let userGroup = userGroups[(indexPath as NSIndexPath).row]
        cell.selectionStyle = .none
        cell.textLabel!.text = userGroup.name
        cell.textLabel!.font = UIFont.systemFont(ofSize: 10) // RobotoFont.regular
        
        cell.detailTextLabel?.text = "Select to see more details"
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.lineBreakMode = .byWordWrapping
        
        cell.detailTextLabel!.font = UIFont.systemFont(ofSize: 10) // RobotoFont.regular
        cell.detailTextLabel!.textColor = MaterialColor.grey.darken1
        cell.imageView?.image = UIImage(named: "default_group")

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if userGroups.count > 1 {
            return 50
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let groupMainViewController = self.storyboard?.instantiateViewController(withIdentifier: "groupMainViewController") as? GroupMainViewController {
            groupMainViewController.firebaseRef = alphaRef
            groupMainViewController.currentUser = user
            groupMainViewController.groupId = userGroups[(indexPath as NSIndexPath).row].groupId
            self.navigationController?.pushViewController(groupMainViewController, animated: true)
        }
        
    }


}

