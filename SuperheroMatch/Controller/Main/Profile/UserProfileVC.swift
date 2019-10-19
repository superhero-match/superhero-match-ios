//
//  UserProfileVC.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 12/10/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit

class UserProfileVC: UIViewController {
    
    let profileImageView: UIImageView = {
        let piv = UIImageView(image: UIImage(named: "test"))
        piv.contentMode = .scaleAspectFill
        piv.clipsToBounds = true
        piv.tappable = true
        
        return piv
    }()
    
    let userName: UILabel = {
        let userName = UILabel()
        userName.font = UIFont(name: "Gotham Book", size: 22)
        userName.textAlignment = .center
        
        return userName
    }()
    
    let genderAge: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Gotham Book", size: 16)
        lbl.textAlignment = .center
        
        return lbl
    }()
    
    let superPowerImageView: UIImageView = {
        let piv = UIImageView(image: UIImage(named: "superpower"))
        piv.contentMode = .scaleAspectFill
        piv.clipsToBounds = true
        
        return piv
    }()
    
    let superPower: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Gotham Book", size: 18)
        lbl.textAlignment = .left
        lbl.text = "Awesome Super Power that I have and it is just test to see how it looks like on the screen when character length is maxed out."
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.sizeToFit()
        
        return lbl
    }()
    
    lazy var settingsButton: UIButton = {
        var btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "settings")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
        
        return btn
    }()
    
    lazy var editInfoButton: UIButton = {
        var btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "edit")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(editInfoTapped), for: .touchUpInside)
        
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // background color white
        view.backgroundColor = .white
        
        self.navigationItem.title = "Profile"
        
        navigationController?.navigationBar.isTranslucent = false

        view.addSubview(profileImageView)
        profileImageView.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: view.frame.height * 0.5)
        profileImageView.callback = handleMainProfileImageTapped
        
        view.addSubview(userName)
        userName.anchor(top: profileImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
        
        view.addSubview(genderAge)
        genderAge.anchor(top: userName.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 5, paddingRight: 0, width: 0, height: 25)

        userName.text = "Superhero"
        genderAge.text = "Gender, Age"
        
        view.addSubview(superPowerImageView)
        superPowerImageView.anchor(top: genderAge.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 25, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        view.addSubview(superPower)
        superPower.anchor(top: genderAge.bottomAnchor, left: superPowerImageView.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: view.frame.width, height: 80)
        
        view.addSubview(settingsButton)
        settingsButton.anchor(top: superPower.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 40, width: 40, height: 40)
        
        view.addSubview(editInfoButton)
        editInfoButton.anchor(top: superPower.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 40, paddingBottom: 0, paddingRight: 20, width: 40, height: 40)
        
    }
    
    @objc func handleMainProfileImageTapped() {
        print("handleMainProfileImageTapped")
    }
    
    @objc func editInfoTapped() {
        
        let editProfileInfoVC = EditProfileInfoVC()
        self.navigationController?.pushViewController(editProfileInfoVC, animated: false)
        
    }
    
    @objc func settingsTapped() {
        
        let profileSettingsVC = ProfileSettingsVC()
        self.navigationController?.pushViewController(profileSettingsVC, animated: false)
        
    }
    
}
