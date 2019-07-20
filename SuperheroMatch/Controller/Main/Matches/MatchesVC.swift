//
//  MatchesVC.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 18/07/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MatchesTableViewCell"

class MatchesVC: UITableViewController {

    var matches : [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 100
        
        fetchMatches()
        
        tableView.register(MatchesTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        constructNavigationController()
    }
    
    func constructNavigationController() {
        self.navigationItem.title = "Matches"
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return matches.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MatchesTableViewCell
        
        cell.user = matches[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
//        let messagesController = MessagesVC()
//        navigationController?.pushViewController(messagesController, animated: true)
        
        let chatController = ChatController(collectionViewLayout: UICollectionViewFlowLayout())
        chatController.user = matches[indexPath.row]
        navigationController?.pushViewController(chatController, animated: true)
    }
    
    func fetchMatches() {
        
        let match1 = User(userID: "id1", email: nil, name: "Superhero 1", superheroName: "Superhero 1", mainProfilePicUrl: "main profile pic", profilePicsUrls: ["pic 1", "pic 2"], gender: 1, lookingForGender: nil, age: 25, lookingForAgeMin: nil, lookingForAgeMax: nil, lookingForDistanceMax: nil, distanceUnit: nil, lat: nil, lon: nil, birthday: nil, country: nil, city: nil, superPower: "Super Power 1", accountType: "FREE")
        matches.append(match1)
        
        let match2 = User(userID: "id2", email: nil, name: "Superhero 2", superheroName: "Superhero 2", mainProfilePicUrl: "main profile pic", profilePicsUrls: ["pic 1", "pic 2"], gender: 1, lookingForGender: nil, age: 25, lookingForAgeMin: nil, lookingForAgeMax: nil, lookingForDistanceMax: nil, distanceUnit: nil, lat: nil, lon: nil, birthday: nil, country: nil, city: nil, superPower: "Super Power 2", accountType: "FREE")
        matches.append(match2)
        
        let match3 = User(userID: "id3", email: nil, name: "Superhero 3", superheroName: "Superhero 3", mainProfilePicUrl: "main profile pic", profilePicsUrls: ["pic 1", "pic 2"], gender: 1, lookingForGender: nil, age: 25, lookingForAgeMin: nil, lookingForAgeMax: nil, lookingForDistanceMax: nil, distanceUnit: nil, lat: nil, lon: nil, birthday: nil, country: nil, city: nil, superPower: "Super Power 3", accountType: "FREE")
        matches.append(match3)
        
    }

}
