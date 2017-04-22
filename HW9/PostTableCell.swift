//
//  PostTableCell.swift
//  HW9
//
//  Created by Chengyu_Ovaltine on 4/14/17.
//  Copyright © 2017 Chengyu_Ovaltine. All rights reserved.
//

import UIKit

class PostTableCell: UITableViewCell {
    @IBOutlet weak var postProfile: UIImageView!
    @IBOutlet weak var postMes: UILabel!
    @IBOutlet weak var postDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
