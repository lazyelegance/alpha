//
//  ParitySelectionCell.swift
//  alpha
//
//  Created by Ezra Bathini on 20/07/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import Firebase


class ParitySelectionCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: AsyncImageView!

    @IBOutlet weak var userNameLabel: UILabel!
    
    var isClicked: Bool? {
        didSet {
            print("IS CLICKED DID SET")
            if let item = isClicked {
                if item == true {
                    profileImageView.layer.borderColor = MaterialColor.white.cgColor
                    userNameLabel.textColor = MaterialColor.white
                } else {
                    profileImageView.layer.borderColor = MaterialColor.blueGrey.base.cgColor
                    userNameLabel.textColor = MaterialColor.blueGrey.base
                }
            }
            profileImageView.layer.borderWidth = 2
            
        }
    }
    
    
    var user: User? {
        didSet {
            
            self.selectionStyle = .none
            
            if let item = user {
                self.backgroundColor = MaterialColor.clear
                self.contentView.backgroundColor = MaterialColor.clear
                
                self.userNameLabel.textColor = MaterialColor.white
                self.userNameLabel.font = UIFont.systemFont(ofSize: 20) //RobotoFont.boldWithSize(20)
                self.userNameLabel.text = item.name
                
                
                profileImageView.layer.masksToBounds = true
                profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
                
                
                profileImageView.imageURL = URL(string: "https://lh3.googleusercontent.com/-r0dVVRlY-DE/AAAAAAAAAAI/AAAAAAAAADw/F5ns-7HdrkE/photo.jpg")
                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
