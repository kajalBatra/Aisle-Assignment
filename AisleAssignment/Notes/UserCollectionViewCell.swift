//
//  UserCollectionViewCell.swift
//  AisleAssignment
//
//  Created by Kajal Batra on 18/03/23.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    func setData(_ data: User) {
        userImageView.setImage(string: data.avatar)
        userImageView.addBlur()
        
        userNameLabel.text = data.firstName
    }
    
}
