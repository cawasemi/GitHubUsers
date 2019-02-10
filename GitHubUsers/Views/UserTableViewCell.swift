//
//  UserTableViewCell.swift
//  GitHubUsers
//
//  Created by Shusaku Harada on 2019/02/10.
//  Copyright © 2019 Shusaku Harada. All rights reserved.
//

import UIKit
import Nuke

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var userIconView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userIconView.image = nil
        userNameLabel.text = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        Nuke.cancelRequest(for: userIconView)
        userNameLabel.text = nil
    }
    
    func prepareUserData(iconUrl: String?, userName: String?) {
        if let urlString = iconUrl, let imageUrl = URL(string: urlString) {
            Nuke.loadImage(with: imageUrl, into: userIconView)
        }
        userNameLabel.text = userName
    }
}
