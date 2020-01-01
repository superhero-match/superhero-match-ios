//
//  ChatVC.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 21/07/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices
import AVFoundation

private let reuseIdentifier = "ChatCell"

class ChatController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    var chat: Chat?
    var messages = [Message]()
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        player?.pause()
        playerLayer?.removeFromSuperlayer()
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
        cell.delegate = self
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
        let currentUid = "1"
        
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(message.messageText!).width + 32
        cell.frame.size.height = estimateFrameForText(message.messageText!).height + 20
        cell.messageImageView.isHidden = true
        cell.textView.isHidden = false
        cell.bubbleView.backgroundColor  = UIColor.rgb(red: 0, green: 137, blue: 249)
        
        
        if message.messageSenderId == currentUid {
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
            cell.textView.textColor = .white
            cell.profileImageView.isHidden = true
        } else {
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
            cell.bubbleView.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
            cell.textView.textColor = .black
            cell.profileImageView.isHidden = false
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
    
    func uploadMessageToServer(withProperties properties: [String: AnyObject]) {
        let currentUid = "1"
        guard let chat = self.chat else { return }
        let creationDate = Int(NSDate().timeIntervalSince1970)
        
        var values: [String: AnyObject] = ["toId": chat.matchedUserId as AnyObject, "fromId": currentUid as AnyObject, "creationDate": creationDate as AnyObject, "read": false as AnyObject]
        
        properties.forEach({values[$0] = $1})
        
        uploadMessageNotification(isImageMessage: false, isVideoMessage: false, isTextMessage: true)
    }
    
    func observeMessages() {
        print("observeMessages")
    }
    
    func fetchMessage(withMessageId messageId: String) {
        let message = Message(messageId: 3, messageChatId: "1", messageSenderId: "Superhero 1", messageReceiverId: "Superhero 2", messageText: "Super message", messageCreated: "17:10 2019-07-21", messageUUID: "uuid3")
        self.messages.append(message)
        
        DispatchQueue.main.async(execute: {
            self.collectionView?.reloadData()
            let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
            self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
        })
        self.setMessageToRead(forMessageId: messageId, fromId: message.messageSenderId)
    }
    
    func uploadMessageNotification(isImageMessage: Bool, isVideoMessage: Bool, isTextMessage: Bool) {
        print("uploadMessageNotification")
        
        let message = Message(messageId: 4, messageChatId: "1", messageSenderId: "Superhero 1", messageReceiverId: "Superhero 2", messageText: "Another super message", messageCreated: "17:15 2019-07-21", messageUUID: "uuid4")
        self.messages.append(message)
        
        self.collectionView?.reloadData()
        let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
        self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
    func uploadImageToStorage(selectedImage image: UIImage, completion: @escaping (_ imageUrl: String) -> ()) {
        let filename = NSUUID().uuidString
        guard let uploadData = image.jpegData(compressionQuality: 1.0) else { return }
        
        print("uploadImageToStorage")
    }
    
    func sendMessage(withImageUrl imageUrl: String, image: UIImage) {
        let properties = ["imageUrl": imageUrl, "imageWidth": image.size.width as Any, "imageHeight": image.size.height as Any] as [String: AnyObject]
        
        self.uploadMessageToServer(withProperties: properties)
        self.uploadMessageNotification(isImageMessage: true, isVideoMessage: false, isTextMessage: false)
    }
    
    func uploadVideoToStorage(withUrl url: URL) {
        let filename = NSUUID().uuidString
        
        print("uploadVideoToStorage")
    }
    
    func thumbnailImage(forFileUrl fileUrl: URL) -> UIImage? {
        let asset = AVAsset(url: fileUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let time = CMTimeMake(value: 1, timescale: 60)
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
        } catch let error {
            print("DEBUG: Exception error: ", error)
        }
        return nil
    }
    
    func setMessageToRead(forMessageId messageId: String, fromId: String) {
        print("setMessageToRead")
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ChatController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let videoUrl = info[.mediaURL] as? URL {
            uploadVideoToStorage(withUrl: videoUrl)
        } else if let selectedImage = info[.editedImage] as? UIImage {
            uploadImageToStorage(selectedImage: selectedImage) { (imageUrl) in
                self.sendMessage(withImageUrl: imageUrl, image: selectedImage)
            }
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - MessageInputAccesoryViewDelegate

extension ChatController: MessageInputAccesoryViewDelegate {
    
    func handleUploadMessage(message: String) {
        let properties = ["messageText": message] as [String: AnyObject]
        uploadMessageToServer(withProperties: properties)
        
        self.containerView.clearMessageTextView()
    }
    
    func handleSelectImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        present(imagePickerController, animated: true, completion: nil)
    }
}

// MARK: - ChatCellDelegate

extension ChatController: ChatCellDelegate {
    
    func handlePlayVideo(for cell: ChatCell) {
        guard let player = self.player else { return }
        guard let playerLayer = self.playerLayer else { return }
        playerLayer.frame = cell.bubbleView.bounds
        cell.bubbleView.layer.addSublayer(playerLayer)
        
        cell.activityIndicatorView.startAnimating()
        player.play()
        cell.playButton.isHidden = true
    }
}

