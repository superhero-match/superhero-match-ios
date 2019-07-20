//
//  NewMessageVC.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 21/07/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "NewMessageCell"

class NewMessageVC: UITableViewController {
    
    // MARK: - Properties
    
    var users = [User]()
    var messagesController: MessagesVC?
    var user: User?
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load from local db
        self.user = User(userID: "id1", email: "email", name: "Superhero 1", superheroName: "Superhero 1", mainProfilePicUrl: "main profile pic", profilePicsUrls: ["pic 1", "pic 2"], gender: 1, lookingForGender: nil, age: 25, lookingForAgeMin: nil, lookingForAgeMax: nil, lookingForDistanceMax: nil, distanceUnit: nil, lat: nil, lon: nil, birthday: nil, country: nil, city: nil, superPower: "Super Power 1", accountType: "FREE")
        
        configureNavigationBar()
        
        // register cell
        tableView.register(NewMessageCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        // removes separator views from unused rows
        tableView.tableFooterView = UIView(frame: .zero)
        
        fetchUsers()
    }
    
    // MARK: - UITableView
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NewMessageCell
        
        cell.user = users[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.dismiss(animated: true) {
            let user = self.users[indexPath.row]
            self.messagesController?.showChatController(forUser: user)
        }
    }
    
    // MARK: - Handlers
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func configureNavigationBar() {
        navigationItem.title = "New Message"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    // MARK: - API
    
    func fetchUsers() {
        self.users.append(self.user!)
        self.tableView.reloadData()
    }
}
