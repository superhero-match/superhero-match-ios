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
    
    var chats = [Chat]()
    var messagesController: MessagesVC?
    var chat: Chat?
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load from local db

        
        configureNavigationBar()
        
        // register cell
        tableView.register(NewMessageCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        // removes separator views from unused rows
        tableView.tableFooterView = UIView(frame: .zero)
        
        fetchChats()
    }
    
    // MARK: - UITableView
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NewMessageCell
        
        cell.chat = chats[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.dismiss(animated: true) {
            let chat = self.chats[indexPath.row]
            self.messagesController?.showChatController(forChat: chat)
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
    
    func fetchChats() {
        self.chats.append(self.chat!)
        self.tableView.reloadData()
    }
}
