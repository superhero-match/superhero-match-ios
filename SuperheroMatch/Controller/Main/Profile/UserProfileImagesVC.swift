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
import SocketIO
import MBProgressHUD

private let reuseIdentifier = "ProfileImageCell"

class UserProfileImagesVC: UICollectionViewController , UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var user: Superhero?
    var loadedUser: Superhero?
    var profilePictures : [ProfilePicture] = []
    var manager: SocketManager!
    var socket: SocketIOClient!
    var timer = Timer()
    var position: Int?
    var deleteProfilePicture: DeleteProfilePicture?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(ProfileImageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView?.backgroundColor = .white
        
        self.collectionView?.isPagingEnabled = true
        
        let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 1.0
        self.collectionView?.addGestureRecognizer(longPressGesture)
        
        self.collectionView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))

        // Do any additional setup after loading the view.
        if let loadedUser = self.loadedUser {
            
            self.user = loadedUser
            
            let profilePicture: ProfilePicture = ProfilePicture(superheroId: self.user?.userID, profilePicUrl: self.user?.mainProfilePicUrl, position: 0)
            
            profilePictures.append(profilePicture)
            
            for pp in self.user!.profilePictures {
                profilePictures.append(pp)
            }
            
        } else {
            // Display an error message
            print("UserProfileImagesVC  -->  did not load user")
        }
        
        self.manager = SocketManager(socketURL: URL(string: "\(ConstantRegistry.BASE_SERVER_URL)\(ConstantRegistry.SUPERHERO_UPDATE_MEDIA_PORT)")!, config: [.log(true), .forceWebsockets(true), .secure(true), .selfSigned(true), .sessionDelegate(CustomSessionDelegate())])
        
        self.socket = self.manager.defaultSocket
        
        self.socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        
        self.socket.on(ConstantRegistry.UPDATE_PROFILE_PICTURE_URL) {[weak self] data, ack in
            
            self!.timer.invalidate()
            self!.timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [weak self] _ in
                
                self!.collectionView.reloadData()
                MBProgressHUD.hide(for: self!.view, animated: true)
                
            }
            
        }
        
        switch self.socket.status {
        case SocketIOStatus.connected:
            print("socket already connected")
        case SocketIOStatus.connecting:
            print("socket is connecting")
        case SocketIOStatus.disconnected:
            self.socket.connect()
        case SocketIOStatus.notConnected:
            self.socket.connect()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.manager = SocketManager(socketURL: URL(string: "\(ConstantRegistry.BASE_SERVER_URL)\(ConstantRegistry.SUPERHERO_UPDATE_MEDIA_PORT)")!, config: [.log(true), .forceWebsockets(true), .secure(true), .selfSigned(true), .sessionDelegate(CustomSessionDelegate())])
        
        self.socket = self.manager.defaultSocket
        
        self.socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        
        self.socket.on(ConstantRegistry.UPDATE_PROFILE_PICTURE_URL) {[weak self] data, ack in
            
            self!.timer.invalidate()
            self!.timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [weak self] _ in
                
                MBProgressHUD.hide(for: self!.view, animated: true)
                NotificationCenter.default.post(name: Notification.Name("ReloadProfileNotification"), object: nil, userInfo: nil)
                
            }
            
        }
        
        switch self.socket.status {
        case SocketIOStatus.connected:
            print("socket already connected")
        case SocketIOStatus.connecting:
            print("socket is connecting")
        case SocketIOStatus.disconnected:
            self.socket.connect()
        case SocketIOStatus.notConnected:
            self.socket.connect()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.socket.disconnect()
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Selected image
        guard let profileImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        let imageData: Data = profileImage.pngData()!
        let imageStrBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        
        let userID: String = (self.user?.userID) as! String
        
        let pos: Int = self.profilePictures[self.position!].position
        
        print("@@@@@  pos  @@@@@")
        print(pos)
        
        self.socket.emit(ConstantRegistry.ON_UPDATE_PROFILE_PICTURE, userID, imageStrBase64, pos)
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func configureDeleteProfilePictureRequestParameters(superheroId: String!, position: Int!) -> [String: Any] {
        
        var params = [String: Any]()
        
        params["superheroId"] = superheroId
        params["position"] = position
        
        return params
        
    }
    
    func deleteProfilePic(params: [String: Any]) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        self.deleteProfilePicture = DeleteProfilePicture()
        self.deleteProfilePicture!.deleteProfilePicture(params: params) { json, error in
            do {
                
                //Convert to Data
                let jsonData = try JSONSerialization.data(withJSONObject: json!, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                //In production, you usually want to try and cast as the root data structure. Here we are casting as a dictionary. If the root object is an array cast as [Any].
                let deleteProfilePictureResponse = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? AnyObject
                
                let response = deleteProfilePictureResponse as! [String : Int]
                
                if response["status"] != 200  {
                    print("Error!")
                    
                    return
                }
                
                self.timer.invalidate()
                self.timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [weak self] _ in
                    
                    MBProgressHUD.hide(for: self!.view, animated: true)
                    NotificationCenter.default.post(name: Notification.Name("ReloadProfileNotification"), object: nil, userInfo: nil)
                    
                }

                
            } catch {
                print("catch in deleteProfilePicture")
            }
        }
        
    }
    
    func showDeleteProfilePictureAlert() {
        let alert = UIAlertController(title: "Delete profile picture?", message: "", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.default, handler: { _ in
            
            let userID: String = (self.user?.userID) as! String
            let pos: Int = self.position!
            
            self.deleteProfilePic(params: self.configureDeleteProfilePictureRequestParameters(superheroId: userID, position: pos))
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            // Don't delete
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showCantDeleteMainProfilePictureAlert() {
        let alert = UIAlertController(title: "Can't delete main profile picture", message: "You can't delete main profile picture, you can only update it.", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            // Don't delete
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func handleTap(gesture: UITapGestureRecognizer){
        
        let p = gesture.location(in: self.collectionView)
        
        let indexPath = self.collectionView.indexPathForItem(at: p)
        
        self.position = indexPath?.item
        
        print("!!!  position handleTap  !!!")
        print(position)
        
        // Configure image picker
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        // present image picker
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer){
        
        let p = gesture.location(in: self.collectionView)
        
        let indexPath = self.collectionView.indexPathForItem(at: p)
        
        self.position = indexPath?.item
        
        print("!!!  position handleLongPress  !!!")
        print(position)
        
        if self.position == 0 {
            showCantDeleteMainProfilePictureAlert()
        } else {
            showDeleteProfilePictureAlert()
        }
        
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ((self.user?.profilePictures.count)! + 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProfileImageCell
        
        cell.imageUrl = self.profilePictures[indexPath.item].profilePicUrl
        cell.nameAndAge = self.user!.superheroName + ", \(self.user?.age ?? 0)"
        cell.location = self.user!.city
        cell.superpower = self.user?.superpower
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
