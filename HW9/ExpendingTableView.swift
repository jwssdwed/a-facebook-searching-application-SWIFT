//
//  ExpendingTableView.swift
//  HW9
//
//  Created by Chengyu_Ovaltine on 4/13/17.
//  Copyright © 2017 Chengyu_Ovaltine. All rights reserved.
//

import UIKit

class ExpendingTableView: UITableViewCell {
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var firstPic: UIImageView!
    @IBOutlet weak var secondPic: UIImageView!
    
    class var expendedHeight: CGFloat {get {return 515}}
    class var defaultHeight: CGFloat {get {return 44 }}
    
    func checkHeight(){
        firstPic.isHidden = frame.size.height < ExpendingTableView.expendedHeight
        secondPic.isHidden = frame.size.height < ExpendingTableView.expendedHeight
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func watchFrameChanges(){
        checkHeight()
    }
    
}
