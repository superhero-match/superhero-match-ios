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
import MobileCoreServices
import AVFoundation
import SocketIO

private let reuseIdentifier = "ChatCell"

class ChatController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    var chat: Chat?
    var messages = [Message]()
    let userDB = UserDB.sharedDB
    let chatDB = ChatDB.sharedDB
    var manager: SocketManager!
    var socket: SocketIOClient!
    
    lazy var containerView: MessageInputAccesoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
        let containerView = MessageInputAccesoryView(frame: frame)
        containerView.delegate = self
        
        return containerView
    }()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 16, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(ChatCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.keyboardDismissMode = .interactive
        
        configureNavigationBar()
        configureKeyboardObservers()
        
        observeMessages()
        
        self.manager = SocketManager(socketURL: URL(string: "\(ConstantRegistry.BASE_SERVER_URL)\(ConstantRegistry.SUPERHERO_CHAT_PORT)")!, config: [.log(true), .forceWebsockets(true), .secure(true), .selfSigned(true), .sessionDelegate(CustomSessionDelegate())])
        
        self.socket = self.manager.defaultSocket
        
        self.socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        
        self.socket.on(ConstantRegistry.MESSAGE) {[weak self] data, ack in
            
            
            
        }
        
        self.socket.connect()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.socket.connect()
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.socket.disconnect()
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        
        let message = messages[indexPath.item]
        
        height = estimateFrameForText(message.messageText).height + 20
 
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ChatCell
        cell.message = messages[indexPath.item]
        configureMessage(cell: cell, message: messages[indexPath.item])
        
        return cell
        
    }
    
    // MARK: - Handlers
    
    @objc func handleInfoTapped() {
        // Add network call to fetch suggestions profile data
        print("handleInfoTapped")
//        let profileController = ProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
//        profileController.user = user
//        navigationController?.pushViewController(profileController, animated: true)
    }
    
    @objc func handleKeyboardDidShow() {
        scrollToBottom()
    }
    
    func estimateFrameForText(_ text: String) -> CGRect {
        
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
        
    }
    
    func configureMessage(cell: ChatCell, message: Message) {
        
        let (dbErr, user) = self.userDB.getUser()
        if case .SQLError = dbErr {
            print("###########  getUser dbErr  ##############")
            print(dbErr)
        }
        
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(message.messageText!).width + 32
        cell.frame.size.height = estimateFrameForText(message.messageText!).height + 20
        cell.textView.isHidden = false
        cell.bubbleView.backgroundColor  = .white //UIColor.rgb(red: 0, green: 137, blue: 249)
        
        
        if message.messageSenderId == user?.userID {
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
            cell.textView.textColor = .black
            cell.profileImageView.isHidden = true
        } else {
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
            cell.bubbleView.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
            cell.textView.textColor = .black
        }
        
    }
    
    func configureNavigationBar() {
        
        guard let chat = self.chat else { return }
        
        navigationItem.title = chat.chatName
        
        let infoButton = UIButton(type: .infoLight)
        infoButton.tintColor = .black
        infoButton.addTarget(self, action: #selector(handleInfoTapped), for: .touchUpInside)
        let infoBarButtonItem = UIBarButtonItem(customView: infoButton)
        
        navigationItem.rightBarButtonItem = infoBarButtonItem
        
    }
    
    func configureKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    func scrollToBottom() {
        if messages.count > 0 {
            let indexPath = IndexPath(item: messages.count - 1, section: 0)
            collectionView?.scrollToItem(at: indexPath, at: .top, animated: true)
        }
    }
    
    // MARK: - API
    
    func uploadMessageToServer(outgoingMessage: [String: Any]) {
        
        // Send message to server
        // self.socket.emit...
        
        uploadMessageNotification(outgoingMessage: outgoingMessage)
        
    }
    
    func observeMessages() {
        print("observeMessages")
    }
    
    func fetchMessage(withMessageId messageId: String) {
        
        let message = Message(messageId: 3, messageChatId: "1", messageSenderId: "Superhero 1", messageText: "Super message", messageCreated: "17:10 2019-07-21")
        self.messages.append(message)
        
        DispatchQueue.main.async(execute: {
            self.collectionView?.reloadData()
            let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
            self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
        })
        
        self.setMessageToRead(forMessageId: messageId, fromId: message.messageSenderId)
        
    }
    
    func uploadMessageNotification(outgoingMessage: [String: Any]) {
        
        let message = Message(messageId: nil, messageChatId: self.chat?.chatID, messageSenderId: outgoingMessage["senderId"] as? String, messageText: outgoingMessage["message"] as? String, messageCreated: outgoingMessage["createdAt"] as? String)
        self.messages.append(message)
        
        self.collectionView?.reloadData()
        let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
        self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
        
    }

    func setMessageToRead(forMessageId messageId: String, fromId: String) {
        print("setMessageToRead")
    }
}

// MARK: - MessageInputAccesoryViewDelegate

extension ChatController: MessageInputAccesoryViewDelegate {
    
    func handleUploadMessage(message: String) {
        
        if message.count == 0 {
            return
        }
        
        let (dbErr, user) = self.userDB.getUser()
        if case .SQLError = dbErr {
            print("###########  getUser dbErr  ##############")
            print(dbErr)
        }
        
        // 1. Save this message to local database
        let dateFormatter: DateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let date: String = dateFormatter.string(from: Date())
        
        let (err, _) = self.chatDB.insertChatMessage(messageSenderId: user?.userID, messageChatId: self.chat?.chatID, messageHasBeenRead: ConstantRegistry.MESSAGE_HAS_BEEN_READ, messageCreated: date, messagetText: message)
        if case .SQLError = err {
            print("###########  insertChatMessage dbErr  ##############")
            print(err)
        }
        
        // 2. Construct outgoing message object
        var outgoingMessage = [String: Any]()
        outgoingMessage["messageType"] = ConstantRegistry.MESSAGE
        outgoingMessage["senderId"] = user?.userID
        outgoingMessage["receiverId"] = self.chat?.matchedUserId
        outgoingMessage["message"] = message
        outgoingMessage["createdAt"] = date
        
        // 3. Call uploadMessageToServer with the outgoing message passed as parameter
        uploadMessageToServer(outgoingMessage: outgoingMessage)
        
        self.containerView.clearMessageTextView()
        
    }
    
}
