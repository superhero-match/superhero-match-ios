//
//  UserProfileImagesVC.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 24/11/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ProfileImageCell"

class UserProfileImagesVC: UICollectionViewController , UICollectionViewDelegateFlowLayout {
    
    var user: User?
    var loadedUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(ProfileImageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView?.backgroundColor = .white
        
        self.collectionView?.isPagingEnabled = true

        // Do any additional setup after loading the view.
        if let loadedUser = self.loadedUser {
            self.user = loadedUser
        } else {
            // Display an error message
            print("UserProfileImagesVC  -->  did not load user")
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.user?.profilePicsUrls!.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProfileImageCell
    
        cell.imageUrl = self.user?.profilePicsUrls![indexPath.item]
        cell.nameAndAge = self.user!.superheroName + ", \(self.user?.age ?? 0)"
        cell.location = self.user!.city
        cell.superpower = self.user?.superPower
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
