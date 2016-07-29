//
//  GroupMainViewController.swift
//  alpha
//
//  Created by Ezra Bathini on 29/07/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import Material

class GroupMainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView: UITableView = UITableView()
    let cardView: CardView = CardView()
    
    var groups = [Group]()
    
    var selectedGroup = Group()

    @IBOutlet weak var selectedGroupView: MaterialView!
    
    @IBOutlet weak var selectedGroupOwing: UILabel!
    
    @IBOutlet weak var selectedGroupTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
        
        prepareGroupsForTableView()
        prepareTableView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func prepareView() {
        view.backgroundColor = MaterialColor.orange.darken1
        selectedGroupView.alpha = 0
        
        print("preparing")
        
        if selectedGroup.groupId != "0" {
            view.backgroundColor = MaterialColor.blue.darken1
            selectedGroupView.backgroundColor = MaterialColor.blue.accent2
            
            
            selectedGroupView.alpha = 1
            selectedGroupOwing.text = "\(selectedGroup.lastExpense)$"
            selectedGroupTitle.text = selectedGroup.name
        }
    }
    
    private func prepareTableView() {
        tableView.registerClass(MaterialTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func prepareGroupsForTableView() {
        
        groups.append(Group(name: "alpha708", lastExpense: 900))
        groups.append(Group(name: "alpha506", lastExpense: 700))
        
        if groups.count > 1 {
            prepareCardView()
            tableView.reloadData()
        }
    }
    
    private func prepareCardView() {
        
        cardView.backgroundColor = MaterialColor.grey.lighten5
        cardView.cornerRadiusPreset = .Radius1
        cardView.divider = false
        cardView.contentInsetPreset = .None
        cardView.leftButtonsInsetPreset = .Square2
        cardView.rightButtonsInsetPreset = .Square2
        cardView.contentViewInsetPreset = .None
        
        let titleLabel: UILabel = UILabel()
        titleLabel.font = RobotoFont.mediumWithSize(20)
        titleLabel.text = "Select Group"
        titleLabel.textAlignment = .Center
        titleLabel.textColor = MaterialColor.blueGrey.darken4
        
        let v: UIView = UIView()
        v.backgroundColor = MaterialColor.blue.accent1
        
        let closeButton: FlatButton = FlatButton()
        closeButton.setTitle("Cancel", forState: .Normal)
        closeButton.setTitleColor(MaterialColor.blue.accent3, forState: .Normal)
        
        let image: UIImage? = MaterialIcon.cm.settings
        let settingButton: IconButton = IconButton()
        settingButton.tintColor = MaterialColor.blue.accent3
        settingButton.setImage(image, forState: .Normal)
        settingButton.setImage(image, forState: .Highlighted)
        
        // Use Layout to easily align the tableView.
        cardView.titleLabel = titleLabel
        cardView.contentView = tableView
        cardView.leftButtons = [closeButton]
//        cardView.rightButtons = [settingButton]
        
        view.layout(cardView).edges(left: 30, right: 30, top: 200, bottom: 200)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count;
    }
    
    /// Returns the number of sections.
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    /// Prepares the cells within the tableView.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: MaterialTableViewCell = MaterialTableViewCell(style: .Subtitle, reuseIdentifier: "Cell")
        
        let item: Group = groups[indexPath.row]
        cell.selectionStyle = .None
        cell.textLabel!.text = item.name
        cell.textLabel!.font = RobotoFont.regular
        cell.detailTextLabel!.text = "\(item.lastExpense)$"
        cell.detailTextLabel!.font = RobotoFont.regular
        cell.detailTextLabel!.textColor = MaterialColor.grey.darken1
//        cell.imageView!.image = item.image?.resize(toWidth: 40)
//        cell.imageView!.layer.cornerRadius = 20
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedGroup = groups[indexPath.row]
        
        //temp
        selectedGroup.groupId = "3"
        prepareView()
//        cardView.removeFromSuperview()
        
        UIView.animateWithDuration(1, animations: { 
            self.cardView.alpha = 0
        }) { (value: Bool) in
                self.cardView.removeFromSuperview()
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
