//
//  NotesListViewController.swift
//  AisleAssignment
//
//  Created by Kajal Batra on 17/03/23.
//

import UIKit

class NotesListViewController: UIViewController {
    @IBOutlet weak var matchCollectionView  : UICollectionView!
    @IBOutlet weak var likesCollectionView  : UICollectionView!
    
    let likesCollectionViewManager = LikesCollectionViewManager()
    let matchCollectionViewManager = MatchCollectionViewManager()
    
    var data: UserProfileData? {
        didSet {
            likesCollectionViewManager.data = data?.likes
            matchCollectionViewManager.data = data?.matches
            likesCollectionView.reloadData()
            matchCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserData()
      
        likesCollectionView.delegate = likesCollectionViewManager
        likesCollectionView.dataSource = likesCollectionViewManager
        
        matchCollectionView.delegate = matchCollectionViewManager
        matchCollectionView.dataSource = matchCollectionViewManager
    }
    
    func getUserData() {
        guard let token = UserDefaults.standard.object(forKey: "authtoken") as? String else {
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
