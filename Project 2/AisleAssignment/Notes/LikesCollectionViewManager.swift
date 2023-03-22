//
//  LikesCollectionViewManager.swift
//  AisleAssignment
//
//  Created by Kajal Batra on 22/03/23.
//

import Foundation
import UIKit


class LikesCollectionViewManager: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var data : Likes?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.profiles.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCollectionViewCell", for: indexPath) as! UserCollectionViewCell
        if let data = data?.profiles[indexPath.row] {
            cell.setData(data)
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width/2.0, height: collectionView.bounds.height)
    }
    
}
