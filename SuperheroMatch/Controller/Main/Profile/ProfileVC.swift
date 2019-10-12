//
//  ProfileVC.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 07/10/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
private let headerIdentifier = "ProfileHeader"

class ProfileVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, ProfileHeaderDelegate {
    
    var user: User?
    
    var userToLoadFromAnotherVC: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // background color white
        self.collectionView?.backgroundColor = .white
        if let userToLoadFromAnotherVC = self.userToLoadFromAnotherVC {
            self.user = userToLoadFromAnotherVC
        } else {
            self.user = User(userID: "id1", email: "superhero1@email.com", name: "Superhero 1", superheroName: "Superhero 1", mainProfilePicUrl: "main profile pic", profilePicsUrls: ["pic 1", "pic 2"], gender: 1, lookingForGender: 2, age: 34, lookingForAgeMin: 18, lookingForAgeMax: 55, lookingForDistanceMax: 20, distanceUnit: "km", lat: 50.12, lon: 5.09, birthday: "1985-05-30", country: "Netherlands", city: "Utrecht", superPower: "Super Power 1", accountType: "CREATOR")
        }

        // Register cell classes
        self.collectionView!.register(ProfileImage.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        self.collectionView?.backgroundColor = .white
        self.navigationItem.title = "Profile"
    }

    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 260)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        
        header.delegate = self
        header.user = self.user
        if self.user?.userID as String? == "id1" {
            header.isUser = true
        }
        header.isUser = true
        navigationItem.title = self.user?.name
        
        return header
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProfileImage

        // cell.imageURL = user?.profilePicsUrls[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        let mainFeedVC = MainFeedVC(collectionViewLayout: UICollectionViewFlowLayout())
//
//        mainFeedVC.viewSinglePost = true
//
//        let post = Post(postId: "1", user: self.user!, caption: "test caption", likes: 5, imageUrl: "url here", creatorId: self.user?.userId, creationDate: Date())
//
//        mainFeedVC.post = post
//
//        navigationController?.pushViewController(mainFeedVC, animated: true)
//
//    }
    
    func handleSettingsTapped(for header: ProfileHeader) {
        print("handleSettingsTapped")
    }
    
    func handleEditInfoTapped(for header: ProfileHeader) {
        print("handleEditInfoTapped")
    }
    
    func handleLikeTapped(for header: ProfileHeader) {
        print("handleLikeTapped")
    }
    
    func handleDislikeTapped(for header: ProfileHeader) {
        print("handleDislikeTapped")
    }
    
    func handleProfileDetailsTapped(for header: ProfileHeader) {
        print("handleProfileDetailsTapped")
    }
    
    func handleProfileImagesTapped(for header: ProfileHeader) {
        print("handleProfileImagesTapped")
    }


}
