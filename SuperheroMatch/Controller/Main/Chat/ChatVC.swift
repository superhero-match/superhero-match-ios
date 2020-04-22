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
import MBProgressHUD

private let reuseIdentifier = "ChatCell"

class ChatController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    var chat: Chat?
    var messages = [Message]()
    let userDB = UserDB.sharedDB
    let chatDB = ChatDB.sharedDB
    var manager: SocketManager!
    var socket: SocketIOClient!
    var suggestionProfile: SuggestionProfile?
    
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
        
        let (err, msgs) = self.chatDB.getAllMessagesForChatWithId(chatId: self.chat?.chatID)
        if case .SQLError = err {
            print("###########  getUser err  ##############")
            print(err)
        }
        
        for message in msgs {
            messages.append(message)
        }
        
        collectionView?.reloadData()
        let indexPath = IndexPath(item: messages.count - 1, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
        
        self.manager = SocketManager(socketURL: URL(string: "\(ConstantRegistry.BASE_SERVER_URL)\(ConstantRegistry.SUPERHERO_CHAT_PORT)")!, config: [.log(true), .forceWebsockets(true), .secure(true), .selfSigned(true), .sessionDelegate(CustomSessionDelegate())])
        
        self.socket = self.manager.defaultSocket
        
        self.socket.on(clientEvent: .connect) {data, ack in
            
            print("socket connected")
            
            let (dbErr, user) = self.userDB.getUser()
            if case .SQLError = dbErr {
                print("###########  getUser dbErr  ##############")
                print(dbErr)
            }
            
            let userId: String = (user?.userID)!
            
            self.socket.emit(ConstantRegistry.ON_OPEN, userId)
            
        }
        
        self.socket.on(ConstantRegistry.MESSAGE) {[weak self] data, ack in
            
            // 1. Save message to local database
            // Determine if this message is for this chat and from that derive wheter message is going to be read
            let messageRead: Int64 = (data[0] as! [String: Any])["senderId"] as? String == self!.chat?.matchedUserId ? ConstantRegistry.MESSAGE_HAS_BEEN_READ : ConstantRegistry.MESSAGE_HAS_NOT_BEEN_READ
            
            // Convert createdAt from UTC to local time
            let createdAtUTC: String = ((data[0] as! [String: Any])["createdAt"] as? String)!
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            
            let dt = dateFormatter.date(from: createdAtUTC)
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            let createdAtLocal: String = dateFormatter.string(from: dt!)
            
            // Get message
            let message: String = ((data[0] as! [String: Any])["message"] as? String)!
            
            // Get senderId
            let senderId: String = ((data[0] as! [String: Any])["senderId"] as? String)!
            
            self!.saveMessageToLoacalDB(senderId: senderId, message: message, createdAt: createdAtLocal, messageRead: messageRead)
            
            self!.addMessageToChat(senderId: senderId, message: message, createdAt: createdAtLocal)
            
        }
        
        switch self.socket.status {
        case SocketIOStatus.connected:
            print("socket already connected")
        case SocketIOStatus.connecting:
            print("socket is connecting")
        case SocketIOStatus.disconnected:
            print("socket is disconnected")
            print("###########  self.socket.connect()  ##############")
            self.socket.connect()
        case SocketIOStatus.notConnected:
            print("socket is notConnected")
            print("###########  self.socket.connect()  ##############")
            self.socket.connect()
        }
        
    }
    
    func saveMessageToLoacalDB(senderId: String!, message: String!, createdAt: String!, messageRead: Int64!) {
        
        // Save the message to the local database
        let (err, _) = chatDB.insertChatMessage(messageSenderId: senderId, messageChatId: chat?.chatID, messageHasBeenRead: messageRead, messageCreated: createdAt, messagetText: message)
        if case .SQLError = err {
            print("###########  insertChatMessage dbErr  ##############")
            print(err)
        }
        
    }
    
    func addMessageToChat(senderId: String!, message: String!, createdAt: String!) {
        
        // Check if this message is sent to this chat. If so, add it to the messages list, if not, then do nothing.
        if senderId == chat?.matchedUserId {
            
            let msg = Message(messageId: nil, messageChatId: chat?.chatID, messageSenderId: senderId, messageText: message, messageCreated: createdAt)
            messages.append(msg)
            
            collectionView?.reloadData()
            let indexPath = IndexPath(item: messages.count - 1, section: 0)
            collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {

        self.socket.disconnect()
        super.viewWillDisappear(animated)
        
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
        
        var params = [String: Any]()        
        params["superheroId"] = self.chat?.matchedUserId

        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        self.suggestionProfile = SuggestionProfile()
        self.suggestionProfile!.getSuggestionProfile(params: params) { json, error in
            do {
                
                MBProgressHUD.hide(for: self.view, animated: true)
                
                //Convert to Data
                let jsonData = try JSONSerialization.data(withJSONObject: json!, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                //In production, you usually want to try and cast as the root data structure. Here we are casting as a dictionary. If the root object is an array cast as [Any].
                let suggestionProfileResponse = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? AnyObject
                
                let response = try SuggestionProfileResponse(json: suggestionProfileResponse as! [String : Any])
                
                if response.status != 200 {
                    print("Something went wrong!")
                    
                    return
                }
                
                self.tabBarController?.tabBar.isHidden = true
                
                var matchProfileVC: MatchProfileVC?
                matchProfileVC = MatchProfileVC()
                matchProfileVC!.superhero = response.profile
                self.navigationController?.pushViewController(matchProfileVC!, animated: true)
                
            } catch {
                print("catch in getSuggestionProfile")
            }
        }
        
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
        cell.bubbleView.backgroundColor  = .white
        
        
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
            cell.matchedUserMainProfilePic = self.chat?.matchedUserMainProfilePic
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
        
        self.socket.emit(ConstantRegistry.MESSAGE, outgoingMessage.description.replacingOccurrences(of: "[", with: "{").replacingOccurrences(of: "]", with: "}"))
        
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
