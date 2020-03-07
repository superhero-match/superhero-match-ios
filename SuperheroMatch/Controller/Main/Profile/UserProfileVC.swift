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

class UserProfileVC: UIViewController {
    
    lazy var settingsButton: UIButton = {
        var btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "settings")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
        
        return btn
    }()
    
    lazy var imageGalleryButton: UIButton = {
        var btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "profile_images")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(imageGalleryTapped), for: .touchUpInside)
        
        return btn
    }()
    
    lazy var editInfoButton: UIButton = {
        var btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "edit")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(editInfoTapped), for: .touchUpInside)
        
        return btn
    }()
    
    var user: User?
    
    var userProfileImagesVC: UserProfileImagesVC?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // background color white
        view.backgroundColor = .white
        
        self.navigationItem.title = "Profile"
        
        navigationController?.navigationBar.isTranslucent = false
        
        let profilePicUrls = ["test", "test1", "test2", "test3", "test4", "test5", "test6", "test7", "test8", "test9", "test10", "test11"]
        self.user = User(userID: "userID", email: "email@email.com", name: "Test Superhero", superheroName: "Superhero", mainProfilePicUrl: "test", profilePicsUrls: profilePicUrls, gender: 1, lookingForGender: 2, age: 34, lookingForAgeMin: 25, lookingForAgeMax: 55, lookingForDistanceMax: 20, distanceUnit: "km", lat: 5.1, lon: 51.12, birthday: "1985-05-30", country: "Country", city: "City", superPower: "Awesome Super Power that I have and it is just test to see how it looks like on the screen when character length is maxed out.", accountType: "FREE")
            
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.userProfileImagesVC = UserProfileImagesVC(collectionViewLayout: layout)
        self.userProfileImagesVC!.user = self.user
        
        configureUI()
        
    }
    
    func configureUI() {
        
        addChild(self.userProfileImagesVC!)
        view.addSubview(self.userProfileImagesVC!.view)
        self.userProfileImagesVC!.didMove(toParent: self)
        self.userProfileImagesVC!.view.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: view.frame.width-10, height: view.frame.height * 0.70)
        self.userProfileImagesVC!.view.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(settingsButton)
        settingsButton.anchor(top: userProfileImagesVC!.view.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 40, width: 40, height: 40)
        
        view.addSubview(imageGalleryButton)
        imageGalleryButton.anchor(top: userProfileImagesVC!.view.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        imageGalleryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(editInfoButton)
        editInfoButton.anchor(top: userProfileImagesVC!.view.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 40, paddingBottom: 0, paddingRight: 20, width: 40, height: 40)
        
    }
    
    @objc func handleMainProfileImageTapped() {
        print("handleMainProfileImageTapped")
    }
    
    @objc func editInfoTapped() {
        
        let editProfileInfoVC = EditProfileInfoVC()
        self.navigationController?.pushViewController(editProfileInfoVC, animated: false)
        
    }
    
    @objc func imageGalleryTapped() {
        
        let profileImagesSettingsVC = ProfileImagesSettingsVC()
        profileImagesSettingsVC.mainImageUrl = "test"
        profileImagesSettingsVC.profileImage1Url = "test1"
        profileImagesSettingsVC.profileImage2Url = "test2"
        profileImagesSettingsVC.profileImage3Url = "test3"
        profileImagesSettingsVC.profileImage4Url = "test4"
        self.navigationController?.pushViewController(profileImagesSettingsVC, animated: false)
        
    }
    
    @objc func settingsTapped() {
        
        let profileSettingsVC = ProfileSettingsVC()
        self.navigationController?.pushViewController(profileSettingsVC, animated: false)
        
    }
    
}
