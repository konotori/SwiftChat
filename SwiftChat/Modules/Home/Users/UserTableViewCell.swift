//
//  UserTableViewCell.swift
//  SwiftChat
//
//  Created by Tung Nguyen on 21/08/2021.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet weak var avataImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    //MARK: - View life cycles
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    func configureCell(user: User) {
        self.userNameLabel.text = user.username
        self.statusLabel.text = user.status
        self.setAvatar(avatarLink: user.avatarLink)
    }
    
    private func setAvatar(avatarLink: String) {
        if avatarLink != "" {
            FileStorage.downloadImage(imageUrl: avatarLink) { image in
                self.avataImageView.image = image?.circleMasked
            }
        } else {
            self.avataImageView.image = UIImage(named: "avatar")?.circleMasked
        }
    }

}
