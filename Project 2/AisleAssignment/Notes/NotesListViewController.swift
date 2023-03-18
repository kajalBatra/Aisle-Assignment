//
//  NotesListViewController.swift
//  AisleAssignment
//
//  Created by Kajal Batra on 17/03/23.
//

import UIKit

class NotesListViewController: UIViewController {
    
    @IBOutlet weak var userImageView        : UIImageView!
    @IBOutlet weak var userDetailLabel      : UILabel!
    @IBOutlet weak var likesCollectionView  : UICollectionView!
    
    var token: String?
    
    var data: UserProfileData? {
        didSet {
            userDetailLabel.text = data?.invites?.profiles.first?.details?.displayVal
            userImageView.setImage(string: data?.invites?.profiles.first?.selectedPhoto?.photo)
            likesCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserData()
    }
    
    func getUserData() {
        guard let token = token else {
            present(AlertUtility.alertWith(error: "Invalid token"), animated: true, completion: nil)
            return
        }
        
        let header = ["Authorization": token]
        APIService.shared.request(type: UserProfileData.self, url: .notes_list, httpMethod: .get, headers: header) {
            [weak self] response, error in
            DispatchQueue.main.async {
                if let err = error {
                    self?.present(AlertUtility.alertWith(error: err.localizedDescription), animated: true, completion: nil)
                }
                else if let res = response {
                    self?.data = res
                }
                else {
                    self?.present(AlertUtility.alertWith(error: "Something went wrong."), animated: true, completion: nil)
                }
            }
        }
    }
}

// MARK: - CollectionView
extension NotesListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.likes?.profiles.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCollectionViewCell", for: indexPath) as! UserCollectionViewCell
        if let data = data?.likes?.profiles[indexPath.row] {
            cell.setData(data)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width/2.0, height: collectionView.bounds.height)
    }
}
