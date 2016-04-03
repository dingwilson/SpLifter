//
//  ListTableViewCell.swift
//  SpLifter
//
//  Created by Wilson Ding on 4/3/16.
//  Copyright © 2016 Wilson Ding. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var riderImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var walkingDistance: UILabel!
    @IBOutlet weak var cost: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
