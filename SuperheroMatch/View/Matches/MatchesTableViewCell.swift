//
//  MatchesTableViewCell.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 21/07/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit

class MatchesTableViewCell: UITableViewCell {
    var chat: Chat? {
        
        didSet {
            let name = chat?.chatName
            chatName.text = name
            
            let lastMsg = chat?.lastActivityMessage
            lastMessage.text = lastMsg
            
            let profilePic = chat?.matchedUserMainProfilePic
            profileImageView.image = UIImage(named: profilePic!)
        }
        
    }
    
    let profileImageView: UIImageView = {
        let piv = UIImageView()
        piv.contentMode = .scaleAspectFill
        piv.clipsToBounds = true
        piv.backgroundColor = .lightGray
        
        return piv
    }()
    
    let chatName: UILabel = {
        let chatName = UILabel()
        chatName.font = UIFont(name: "Gotham Book", size: 22)
        chatName.textAlignment = .left
        
        return chatName
    }()
    
    let lastMessage: UILabel = {
        let lastMessage = UILabel()
        lastMessage.font = UIFont(name: "Gotham Book", size: 18)
        lastMessage.textAlignment = .left
        
        return lastMessage
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        
        addSubview(chatName)
        chatName.anchor(top: self.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 16, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 35)
        
        addSubview(lastMessage)
        lastMessage.anchor(top: chatName.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 35)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
