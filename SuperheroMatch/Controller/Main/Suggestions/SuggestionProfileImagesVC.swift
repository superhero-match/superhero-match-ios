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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(SuggestionImageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView?.backgroundColor = .white
        
//        if let layout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.scrollDirection = .horizontal
//        }
        
        self.collectionView?.isPagingEnabled = true

        // Do any additional setup after loading the view.
        if let loadedSuggestion = self.loadedSuggestion {
            self.suggestion = loadedSuggestion
        } else {
            // load from local db
            print("SuggestionProfileImagesVC  -->  did not load suggestion")
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.suggestion?.profilePicsUrls!.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SuggestionImageCell
    
        cell.imageUrl = self.suggestion?.profilePicsUrls![indexPath.item]
        cell.nameAndAge = self.suggestion!.superheroName + ", \(self.suggestion?.age ?? 0)"
        cell.location = self.suggestion!.city
        cell.superpower = self.suggestion?.superpower
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}
