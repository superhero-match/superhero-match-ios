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
        
        let message1 = Message(messageId: 1, messageChatId: "1", messageSenderId: "Superhero 1", messageText: "Awesome", messageCreated: "17:04 2019-07-21")
        let chatPartnerId1 = message1.messageSenderId!
        self.messagesDictionary[chatPartnerId1] = message1
        
        let message2 = Message(messageId: 2, messageChatId: "1", messageSenderId: "Superhero 1", messageText: "More awesome", messageCreated: "17:06 2019-07-21")
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

