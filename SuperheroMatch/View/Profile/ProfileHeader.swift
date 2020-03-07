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

class ProfileHeader: UICollectionViewCell {
    
    var delegate: ProfileHeaderDelegate?
    
    var user: User? {

        didSet {
//            let name = "Superhero"//user?.userName
//            userName.text = name
//
//            let ga = "Gender, Age"//user?.gender + user?.age
//            genderAge.text = ga
        }

    }
    
    var isUser = true
    
    let profileImageView: UIImageView = {
        let piv = UIImageView(image: UIImage(named: "user_profile"))
        piv.contentMode = .scaleAspectFill
        piv.clipsToBounds = true
        piv.backgroundColor = .lightGray
        
        return piv
    }()
    
    let userName: UILabel = {
        let userName = UILabel()
        userName.font = UIFont(name: "Gotham Book", size: 20)
        userName.textAlignment = .center
        
        return userName
    }()
    
    let genderAge: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Gotham Book", size: 18)
        lbl.textAlignment = .center
        
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
    
    lazy var dislikeButton: UIButton = {
        var btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "dislike")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(dislikeTapped), for: .touchUpInside)
        
        return btn
    }()
    
    lazy var likeButton: UIButton = {
        var btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "like")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        
        return btn
    }()
    
    let statsDelimeterTopView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    let superPowerImageView: UIImageView = {
        let piv = UIImageView(image: UIImage(named: "superpower"))
        piv.contentMode = .scaleAspectFill
        piv.clipsToBounds = true
        
        return piv
    }()
    
    let superPower: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Gotham Book", size: 20)
        lbl.textAlignment = .left
        lbl.text = "Awesome Super Power"
        
        return lbl
    }()
    
    let statsDelimeterBottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: self.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 120, height: 120)
        profileImageView.layer.cornerRadius = 120 / 2
        profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        addSubview(userName)
        userName.anchor(top: profileImageView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        addSubview(genderAge)
        genderAge.anchor(top: userName.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)

        userName.text = "Superhero"
        genderAge.text = "Gender, Age"
        
        if self.isUser {
            addSubview(settingsButton)
            settingsButton.anchor(top: nil, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 40, width: 40, height: 40)
            settingsButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            
            addSubview(editInfoButton)
            editInfoButton.anchor(top: nil, left: nil, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 40, paddingBottom: 0, paddingRight: 20, width: 40, height: 40)
            editInfoButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        } else {
            addSubview(dislikeButton)
            dislikeButton.anchor(top: nil, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 40, width: 40, height: 40)
            dislikeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            
            addSubview(likeButton)
            likeButton.anchor(top: nil, left: nil, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 40, paddingBottom: 0, paddingRight: 20, width: 40, height: 40)
            likeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        }
        
        addSubview(statsDelimeterTopView)
        statsDelimeterTopView.anchor(top: genderAge.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
        addSubview(superPowerImageView)
        superPowerImageView.anchor(top: statsDelimeterTopView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 20, paddingRight: 0, width: 40, height: 40)
        
        addSubview(superPower)
        superPower.anchor(top: statsDelimeterTopView.bottomAnchor, left: superPowerImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 20, paddingRight: 0, width: 0, height: 40)
        
        addSubview(statsDelimeterBottomView)
        statsDelimeterBottomView.anchor(top: superPowerImageView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func likeTapped() {
        delegate?.handleLikeTapped(for: self)
    }
    
    @objc func dislikeTapped() {
        delegate?.handleDislikeTapped(for: self)
    }
    
    @objc func editInfoTapped() {
        delegate?.handleEditInfoTapped(for: self)
    }
    
    @objc func settingsTapped() {
        delegate?.handleSettingsTapped(for: self)
    }
    
    @objc func profileDetailsTapped() {
        delegate?.handleProfileDetailsTapped(for: self)
    }
    
    @objc func profileImagesTapped() {
        delegate?.handleProfileImagesTapped(for: self)
    }
    
}
