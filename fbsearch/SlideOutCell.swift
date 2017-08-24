//
//  SlideOutCell.swift
//  HW9
//
//  Created by Chengyu_Ovaltine on 4/16/17.
//  Copyright © 2017 Chengyu_Ovaltine. All rights reserved.
//

import UIKit

class SlideOutCell: UITableViewCell {
    @IBOutlet weak var slideImg: UIImageView!
    @IBOutlet weak var slideText: UILabel!
    @IBOutlet weak var exceptCell: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
