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

class MessageCell: UITableViewCell {
    
    // MARK: - Properties
    
    var delegate: MessageCellDelegate?
    
    var message: Message? {
        
        didSet {
            guard let message = self.message else { return }
            guard let messageText = message.messageText else { return }
            let read = true
            
            usernameLabel.text = "Username"
            
            if !read && message.messageSenderId != "Superhero 1" {
                messageTextLabel.font = UIFont.boldSystemFont(ofSize: 12)
            } else {
                messageTextLabel.font = UIFont.systemFont(ofSize: 12)
            }
            
            messageTextLabel.text = messageText
            configureTimestamp(forMessage: message)
            delegate?.configureUserData(for: self)
        }
    }
    
    let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        label.text = "2h"
        
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .black
        
        return label
    }()
    
    let messageTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(messageTextLabel)
        messageTextLabel.anchor(top: usernameLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 6, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(timestampLabel)
        timestampLabel.anchor(top: messageTextLabel.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Handlers
    
    func configureTimestamp(forMessage message: Message) {
        if let seconds = message.messageCreated {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            timestampLabel.text = dateFormatter.string(from: Date())
        }
    }
    
}
