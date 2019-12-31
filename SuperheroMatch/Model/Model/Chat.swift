//
//  Chat.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 18/07/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class Chat {
    
    var chatID: String!
    var chatName: String!
    var matchedUserId: String!
    var matchedUserMainProfilePic: String!
    var lastActivityMessage: String!
    var lastActivityDate: String!
    var unreadMessageCount: Int64!
    
    init(chatID: String!, chatName: String!, matchedUserId: String!, matchedUserMainProfilePic: String!, lastActivityMessage: String!, lastActivityDate: String!, unreadMessageCount: Int64!) {
        
        self.chatID = chatID
        self.chatName = chatName
        self.matchedUserId = matchedUserId
        self.matchedUserMainProfilePic = matchedUserMainProfilePic
        self.lastActivityMessage = lastActivityMessage
        self.lastActivityDate = lastActivityDate
        self.unreadMessageCount = unreadMessageCount
        
    }
    
}
