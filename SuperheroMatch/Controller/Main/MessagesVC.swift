//
//  MessagesVC.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 21/07/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "MessagesCell"

class MessagesVC: UITableViewController {
    
    // MARK: - Properties
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    var chat: Chat?
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load from local db
       
        
        configureNavigationBar()
        
        tableView.register(MessageCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView(frame: .zero)
        
        fetchMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - UITableView
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let uid = "1"
        let message = messages[indexPath.row]
        let chatPartnerId = message.messageReceiverId
        
        self.messages.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MessageCell
        cell.delegate = self as? MessageCellDelegate
        cell.message = messages[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        let chatPartnerId = message.messageReceiverId
        let cell = tableView.cellForRow(at: indexPath) as! MessageCell
        self.showChatController(forChat: self.chat!)
        cell.messageTextLabel.font = UIFont.systemFont(ofSize: 12)
    }
    
    // MARK: - Handlers
    
    @objc func handleNewMessage() {
        let newMessageController = NewMessageVC()
        newMessageController.messagesController = self
        let navigationController = UINavigationController(rootViewController: newMessageController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func showChatController(forChat chat: Chat) {
        let chatController = ChatController(collectionViewLayout: UICollectionViewFlowLayout())
        chatController.chat = chat
        navigationController?.pushViewController(chatController, animated: true)
    }
    
    func configureNavigationBar() {
        navigationItem.title = "Messages"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleNewMessage))
    }
    
    // MARK: - API
    
    func fetchMessages() {
        
        self.messages.removeAll()
        self.messagesDictionary.removeAll()
        self.tableView.reloadData()
        
        let messageId = "1"
        self.fetchMessage(withMessageId: messageId)
        
    }
    
    func fetchMessage(withMessageId messageId: String) {
        
        let message1 = Message(messageId: 1, messageChatId: "1", messageSenderId: "Superhero 1", messageReceiverId: "Superhero 2", messageText: "Awesome", messageCreated: "17:04 2019-07-21", messageUUID: "uuid1")
        let chatPartnerId1 = message1.messageSenderId!
        self.messagesDictionary[chatPartnerId1] = message1
        
        let message2 = Message(messageId: 2, messageChatId: "1", messageSenderId: "Superhero 1", messageReceiverId: "Superhero 2", messageText: "More awesome", messageCreated: "17:06 2019-07-21", messageUUID: "uuid1")
        let chatPartnerId2 = message2.messageSenderId!
        self.messagesDictionary[chatPartnerId2] = message2
        
        self.messages = Array(self.messagesDictionary.values)
        
        self.messages.sort(by: { (message1, message2) -> Bool in
            return message1.messageCreated > message2.messageCreated
        })
        
        self.tableView?.reloadData()
        
    }
}

extension MessagesVC: MessageCellDelegate {
    
    func configureUserData(for cell: MessageCell) {
        guard (cell.message?.messageSenderId) != nil else { return }
        
        //cell.profileImageView.loadImage(with: user.profileImageUrl)
        cell.usernameLabel.text = self.chat!.chatName
        
    }
}

