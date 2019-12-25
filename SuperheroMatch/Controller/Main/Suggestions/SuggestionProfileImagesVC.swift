//
//  SuggestionProfileImagesVC.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 18/11/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SuggestionImagesCell"

class SuggestionProfileImagesVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var suggestion: Superhero?
    var loadedSuggestion: Superhero?
    var profilePicturesUrls: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(SuggestionImageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView?.backgroundColor = .white
        
        self.collectionView?.isPagingEnabled = true

        // Do any additional setup after loading the view.
        if let loadedSuggestion = self.loadedSuggestion {
            self.suggestion = loadedSuggestion
            
            self.profilePicturesUrls.append(self.suggestion!.mainProfilePicUrl)
            
            for profilePicture in self.suggestion!.profilePictures {
                self.profilePicturesUrls.append(profilePicture.profilePicUrl)
            }
        } else {
            // Display error message.
            print("SuggestionProfileImagesVC  -->  did not load suggestion")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadNextSuggestion), name: NSNotification.Name("LoadNextSuggestionNotification"), object: nil)
        
    }
    
    @objc func loadNextSuggestion() {
        print("LoadNextSuggestionNotification has been received")
        // Do any additional setup after loading the view.
        if let loadedSuggestion = self.loadedSuggestion {
            self.suggestion = loadedSuggestion
            
            self.profilePicturesUrls = []
            
            self.profilePicturesUrls.append(self.suggestion!.mainProfilePicUrl)
            
            for profilePicture in self.suggestion!.profilePictures {
                self.profilePicturesUrls.append(profilePicture.profilePicUrl)
            }
        } else {
            // Display error message.
            print("SuggestionProfileImagesVC  -->  did not load suggestion")
        }
        
        self.collectionView?.reloadData()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.profilePicturesUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SuggestionImageCell
    
        cell.imageUrl = self.profilePicturesUrls.count > 0 ? self.profilePicturesUrls[indexPath.item] : ""
        cell.nameAndAge = self.suggestion!.superheroName + ", \(self.suggestion?.age ?? 0)"
        cell.location = self.suggestion!.city
        cell.superpower = self.suggestion?.superpower
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}
