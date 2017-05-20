//
//  CustomCell.swift
//  ChatChat
//
//  Created by Vansh Badkul on 20/05/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    @IBOutlet fileprivate weak var imgFlag: UIImageView!
    @IBOutlet fileprivate weak var lblCountry: UILabel!
    
    var country: String? {
        didSet {
            self.imgFlag.image = UIImage(named: country!)
            self.lblCountry.text = country!
        }
    }
}
