//
//  MatchCollectionViewCell.swift
//  AisleAssignment
//
//  Created by Kajal Batra on 22/03/23.
//

import UIKit

class MatchCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    
    func setData(_ data: MatchUser) {
        userImageView.setImage(string: data.selectedPhoto?.photo)
        userNameLbl.text = data.details?.firstName
    }
}
