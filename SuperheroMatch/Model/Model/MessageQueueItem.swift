//
//  MessageQueueItem.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 18/07/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class MessageQueueItem {
    
    var _id: Int!
    var messageUUID: String!
    var receiverId: String!
    
    init(_id: Int!, messageUUID: String!, receiverId: String!) {
        
        self._id = _id
        self.messageUUID = messageUUID
        self.receiverId = receiverId
        
    }
    
}
