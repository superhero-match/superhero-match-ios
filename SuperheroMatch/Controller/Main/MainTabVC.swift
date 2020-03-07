/*
  Copyright (C) 2019 - 2020 MWSOFT
  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.
  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.
  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

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
//        let suggestionsVC = configureNaviagtionController(unselectedImage: (UIImage(named: "suggestions_inactive") ?? nil)!, selectedImage: (UIImage(named: "suggestions") ?? nil)!, rootViewController: SuggestionsVC(collectionViewLayout: UICollectionViewFlowLayout()))
        
        let suggestionsVC = configureNaviagtionController(unselectedImage: (UIImage(named: "suggestions_inactive") ?? nil)!, selectedImage: (UIImage(named: "suggestions") ?? nil)!, rootViewController: UserSuggestionsVC())
        
        // Matches controller
        let matchesVC = configureNaviagtionController(unselectedImage: (UIImage(named: "matches_inactive") ?? nil)!, selectedImage: (UIImage(named: "matches") ?? nil)!, rootViewController: MatchesVC())
        
        // Profile controller
//        let profileVC = configureNaviagtionController(unselectedImage: (UIImage(named: "user_inactive") ?? nil)!, selectedImage: (UIImage(named: "user") ?? nil)!, rootViewController: ProfileVC(collectionViewLayout: UICollectionViewFlowLayout()))
        
        let profileVC = configureNaviagtionController(unselectedImage: (UIImage(named: "user_inactive") ?? nil)!, selectedImage: (UIImage(named: "user") ?? nil)!, rootViewController: UserProfileVC())
        
        
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
