//
//  MainTabVC.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 18/07/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit

class MainTabVC: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delegate
        self.delegate = self
        
        configureViewControllers()
    }
    
    // Creates all view controllers of the tab bar controller
    func configureViewControllers() {
        
        // Suggestions controller
        let suggestionsVC = configureNaviagtionController(unselectedImage: (UIImage(named: "suggestions_inactive") ?? nil)!, selectedImage: (UIImage(named: "suggestions") ?? nil)!, rootViewController: SuggestionsVC(collectionViewLayout: UICollectionViewFlowLayout()))
        
        // Matches controller
        let matchesVC = configureNaviagtionController(unselectedImage: (UIImage(named: "matches_inactive") ?? nil)!, selectedImage: (UIImage(named: "matches") ?? nil)!, rootViewController: MatchesVC())
        
        // Profile controller
        let profileVC = configureNaviagtionController(unselectedImage: (UIImage(named: "user_inactive") ?? nil)!, selectedImage: (UIImage(named: "user") ?? nil)!, rootViewController: ProfileVC(collectionViewLayout: UICollectionViewFlowLayout()))
        
        // add VCs to tab controller
        viewControllers = [suggestionsVC, matchesVC, profileVC]
        
        tabBar.tintColor = .black
        
    }
    
    // Construct Navigation controller, this is needed to navigate from one controller to another
    func configureNaviagtionController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        
        // construct nav controller
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        navController.navigationBar.tintColor = .black
        
        // return nav controller
        return navController
        
    }

}
