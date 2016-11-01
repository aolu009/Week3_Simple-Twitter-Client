//
//  TweetTableViewCell.swift
//  Week3_Simple Twitter Client
//
//  Created by Lu Ao on 10/29/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var screen_name: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var userProfilePic: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
