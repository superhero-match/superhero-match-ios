//
//  Chat.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 18/07/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class Chat {
    
    var chatID: Int64!
    var chatName: String!
    var matchName: String!
    var lastActivityMessage: String!
    var lastActivityDate: String!
    var unreadMessageCount: Int64!
    
    init(chatID: Int64!, chatName: String!, matchName: String!, lastActivityMessage: String!, lastActivityDate: String!, unreadMessageCount: Int64!) {
        
        self.chatID = chatID
        self.chatName = chatName
        self.matchName = matchName
        self.lastActivityMessage = lastActivityMessage
        self.lastActivityDate = lastActivityDate
        self.unreadMessageCount = unreadMessageCount
        
    }
    
}
