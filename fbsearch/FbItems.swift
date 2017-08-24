//
//  FbItems.swift
//  HW9
//
//  Created by Chengyu_Ovaltine on 4/12/17.
//  Copyright © 2017 Chengyu_Ovaltine. All rights reserved.
//

import UIKit

class FbItems: UITableViewCell {
    @IBOutlet weak var groupProfile: UIImageView!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupFavoriteButton: FavoriteButton!
    
    @IBOutlet weak var placeProfile: UIImageView!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeFavoriteButton: FavoriteButton!
    
    
    @IBOutlet weak var eventProfile: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventFavoriteButton: FavoriteButton!
    
    @IBOutlet weak var pageProfile: UIImageView!
    @IBOutlet weak var pageName: UILabel!
    @IBOutlet weak var pageFavoriteButton: FavoriteButton!
    
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var favoriteButton: FavoriteButton!
    
    @IBOutlet weak var userFavProfile: UIImageView!
    @IBOutlet weak var userFavName: UILabel!
    @IBOutlet weak var userFavFavoriteButton: FavoriteButton!
    
    @IBOutlet weak var pageFavProfile: UIImageView!
    @IBOutlet weak var pageFavName: UILabel!
    @IBOutlet weak var pageFavFavoriteButton: FavoriteButton!
    
    @IBOutlet weak var eventFavProfile: UIImageView!
    @IBOutlet weak var eventFavName: UILabel!
    @IBOutlet weak var eventFavFavoriteButton: FavoriteButton!
    
    @IBOutlet weak var placeFavProfile: UIImageView!
    @IBOutlet weak var placeFavName: UILabel!
    @IBOutlet weak var placeFavFavoriteButton: FavoriteButton!
    
    @IBOutlet weak var groupFavProfile: UIImageView!
    @IBOutlet weak var groupFavName: UILabel!
    @IBOutlet weak var groupFavFavoriteButton: FavoriteButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
