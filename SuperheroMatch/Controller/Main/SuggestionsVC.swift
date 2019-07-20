//
//  SuggestionsVC.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 18/07/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class SuggestionsVC: UICollectionViewController , UICollectionViewDelegateFlowLayout, SuggestionCellDelegate {
    
    var suggestions : [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // background color white
        self.collectionView?.backgroundColor = .white
        
        // Register cell classes
        self.collectionView!.register(SuggestionCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView?.backgroundColor = .white
        self.navigationItem.title = "Suggestions"
        
        fetchSuggestions()
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return suggestions.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SuggestionCell
        
        // cell.imageURL = user?.profilePicsUrls[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 2
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let profileVC = ProfileVC(collectionViewLayout: UICollectionViewFlowLayout())

        profileVC.userToLoadFromAnotherVC = suggestions[indexPath.row]

        navigationController?.pushViewController(profileVC, animated: true)

    }
    
    func handleImageTapped(for cell: SuggestionCell) {
        print("handleImageTapped")
    }
    
    func handleUsernameTapped(for cell: SuggestionCell){
        print("handleUsernameTapped")
    }
    
    
    func fetchSuggestions() {
        
        let suggestion1 = User(userID: "id1", email: nil, name: "Superhero 1", superheroName: "Superhero 1", mainProfilePicUrl: "main profile pic", profilePicsUrls: ["pic 1", "pic 2"], gender: 1, lookingForGender: nil, age: 25, lookingForAgeMin: nil, lookingForAgeMax: nil, lookingForDistanceMax: nil, distanceUnit: nil, lat: nil, lon: nil, birthday: nil, country: nil, city: nil, superPower: "Super Power 1", accountType: "FREE")
        suggestions.append(suggestion1)
        
        let suggestion2 = User(userID: "id2", email: nil, name: "Superhero 2", superheroName: "Superhero 1", mainProfilePicUrl: "main profile pic", profilePicsUrls: ["pic 1", "pic 2"], gender: 1, lookingForGender: nil, age: 25, lookingForAgeMin: nil, lookingForAgeMax: nil, lookingForDistanceMax: nil, distanceUnit: nil, lat: nil, lon: nil, birthday: nil, country: nil, city: nil, superPower: "Super Power 2", accountType: "FREE")
        suggestions.append(suggestion2)
        
        let suggestion3 = User(userID: "id3", email: nil, name: "Superhero 3", superheroName: "Superhero 1", mainProfilePicUrl: "main profile pic", profilePicsUrls: ["pic 1", "pic 2"], gender: 1, lookingForGender: nil, age: 25, lookingForAgeMin: nil, lookingForAgeMax: nil, lookingForDistanceMax: nil, distanceUnit: nil, lat: nil, lon: nil, birthday: nil, country: nil, city: nil, superPower: "Super Power 3", accountType: "FREE")
        suggestions.append(suggestion3)
        
    }
    
    
}
