//
//  CategoryViewController.swift
//  alpha
//
//  Created by Ezra Bathini on 27/07/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import Material

class CategoryViewController: UIViewController {
    
    let categories = ["food", "rent", "entertainment", "groceries"]
    


    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = MaterialColor.indigo.accent1
        
        let w: CGFloat = 200
        let titlelabelorigin = titleLabel.frame.origin
        let titlelabelheight = titleLabel.frame.size.height
        
        
        for i in 0 ..< categories.count {
            let buttonx = (view.bounds.width - w) / 2
            let buttony = titlelabelorigin.y + titlelabelheight + 10 + (50 * CGFloat(i))
            let buttonwidth = view.bounds.width - w
            
                

            let button: RaisedButton = RaisedButton(frame: CGRectMake(buttonx , buttony, buttonwidth, 30))
            button.setTitle(categories[i], forState: .Normal)
            button.setTitleColor(MaterialColor.white, forState: .Normal)
            button.backgroundColor = view.backgroundColor!
            button.pulseColor = MaterialColor.indigo.lighten1
            button.titleLabel!.font = RobotoFont.mediumWithSize(12)
            button.titleLabel?.textAlignment = .Left
            button.layer.shadowOpacity = 0.1

            view.addSubview(button)
        }
        
        
        
        print(view.subviews)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        

        
        

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
