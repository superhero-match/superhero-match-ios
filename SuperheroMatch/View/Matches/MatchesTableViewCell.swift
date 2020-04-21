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

class MatchesTableViewCell: UITableViewCell {
    var chat: Chat? {
        
        didSet {
            let name = chat?.chatName
            chatName.text = name
            
            let lastMsg = chat?.lastActivityMessage
            lastMessage.text = lastMsg
            
            profileImageView.kf.indicatorType = .activity
            profileImageView.kf.setImage(with: URL(string: (chat?.matchedUserMainProfilePic!)!), placeholder: UIImage(named: "user_profile"), options: [.transition(.fade(0.7))], progressBlock: nil)
            
            let dateSplits = chat?.lastActivityDate.components(separatedBy: " ")
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let messageDate = formatter.date(from: dateSplits![0])
            
            let today = Date()
            let todayFormatedStr = formatter.string(from: today)
            let todayFormatedDate = formatter.date(from: todayFormatedStr)
            
            if todayFormatedDate == messageDate {
                
                lastMessageCreatedAt.text = dateSplits![1]
                return
                
            }
            
            lastMessageCreatedAt.text = dateSplits![0]
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
    
    let lastMessageCreatedAt: UILabel = {
        let lastMessageCreatedAt = UILabel()
        lastMessageCreatedAt.font = UIFont(name: "Gotham Book", size: 12)
        lastMessageCreatedAt.textAlignment = .right
        
        return lastMessageCreatedAt
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        
        addSubview(chatName)
        chatName.anchor(top: self.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 150, height: 35)
        
        addSubview(lastMessageCreatedAt)
        lastMessageCreatedAt.anchor(top: self.topAnchor, left: chatName.rightAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 5, width: 0, height: 35)
        
        addSubview(lastMessage)
        lastMessage.anchor(top: chatName.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 35)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
