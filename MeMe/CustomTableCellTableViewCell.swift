//
//  CustomTableCellTableViewCell.swift
//  MeMe
//
//  Created by Tanveer Bashir on 12/2/15.
//  Copyright © 2015 Tanveer Bashir. All rights reserved.
//

import UIKit

class CustomTableCellTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var memeTextLalbel: UILabel!
    @IBOutlet weak var memeImage: UIImageView!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
