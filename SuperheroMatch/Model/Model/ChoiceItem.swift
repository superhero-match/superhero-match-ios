//
//  Choice.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 15/04/2020.
//  Copyright © 2020 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class ChoiceItem {
    
    var choiceId: Int64!
    var chosenUserId: String!
    var choice: Int64!
    var createdAt: String!
    
    init(choiceId: Int64!, chosenUserId: String!, choice: Int64!, createdAt: String!) {
        
        self.choiceId = choiceId
        self.chosenUserId = chosenUserId
        self.choice = choice
        self.createdAt = createdAt
        
    }
    
}
