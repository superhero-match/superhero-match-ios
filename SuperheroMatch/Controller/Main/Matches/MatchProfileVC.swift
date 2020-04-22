//
//  MatchProfileVC.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 22/04/2020.
//  Copyright © 2020 Nikolajus Karpovas. All rights reserved.
//

import UIKit

class MatchProfileVC: UIViewController {
    
    var superhero: Superhero?
    
    var suggestionprofileImagesVC: SuggestionProfileImagesVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // background color white
        view.backgroundColor = .white
        
        self.navigationItem.title = "Profile"
        
        navigationController?.navigationBar.isTranslucent = false
 
        configureUI()
        
    }
    
    func configureUI() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        suggestionprofileImagesVC = SuggestionProfileImagesVC(collectionViewLayout: layout)
        suggestionprofileImagesVC!.loadedSuggestion = self.superhero
        
        addChild(self.suggestionprofileImagesVC!)
        view.addSubview(self.suggestionprofileImagesVC!.view)
        self.suggestionprofileImagesVC!.didMove(toParent: self)
        self.suggestionprofileImagesVC!.view.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: view.frame.width-10, height: view.frame.height * 0.70)
        self.suggestionprofileImagesVC!.view.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }

}
