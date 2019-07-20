//
//  SuggestionCell.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 21/07/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit

class SuggestionCell: UICollectionViewCell {
    
    var delegate: SuggestionCellDelegate?
    
    var user: User? {
        
        didSet {
            //            let name = "Superhero"//user?.userName
            //            userName.text = name
            //
            //            let ga = "Gender, Age"//user?.gender + user?.age
            //            genderAge.text = ga
        }
        
    }
    
    let profileImageView: UIImageView = {
        let piv = UIImageView(image: UIImage(named: "test"))
        piv.contentMode = .scaleAspectFill
        piv.clipsToBounds = true
        
        return piv
    }()
    
    let userNameAge: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Gotham Book", size: 20)
        lbl.textAlignment = .center
        lbl.text = "Superhero, 34"
        
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 120, height: 120)
        profileImageView.layer.cornerRadius = 120 / 2
        profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        addSubview(userNameAge)
        userNameAge.anchor(top: profileImageView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func imageTapped() {
        delegate?.handleImageTapped(for: self)
    }
    
    @objc func userNameTapped() {
        delegate?.handleUsernameTapped(for: self)
    }
    
}
