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

class UserProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var userProfileImagesVC: UserProfileImagesVC?
    var suggestionProfile: SuggestionProfile?
    let userDB = UserDB.sharedDB
    var manager: SocketManager!
    var socket: SocketIOClient!
    var timer = Timer()
    var superhero: Superhero?
    
    lazy var settingsButton: UIButton = {
        var btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "settings")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
        
        return btn
    }()
    
    lazy var addNewProfilePictureButton: UIButton = {
        var btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "new_profile_picture")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(addNewProfilePictureTapped), for: .touchUpInside)
        
        return btn
    }()
    
    lazy var infoButton: UIButton = {
        var btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "info")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(infoTapped), for: .touchUpInside)
        
        return btn
    }()
    
    lazy var editInfoButton: UIButton = {
        var btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "edit")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(editInfoTapped), for: .touchUpInside)
        
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // background color white
        view.backgroundColor = .white
        
        self.navigationItem.title = "Profile"
        
        navigationController?.navigationBar.isTranslucent = false
        
        self.manager = SocketManager(socketURL: URL(string: "\(ConstantRegistry.BASE_SERVER_URL)\(ConstantRegistry.SUPERHERO_UPDATE_MEDIA_PORT)")!, config: [.log(true), .forceWebsockets(true), .secure(true), .selfSigned(true), .sessionDelegate(CustomSessionDelegate())])
        
        self.socket = self.manager.defaultSocket
        
        self.socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        
        self.socket.on(ConstantRegistry.UPDATE_PROFILE_PICTURE_URL) {[weak self] data, ack in
            
            self!.timer.invalidate()
            self!.timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [weak self] _ in
                
                MBProgressHUD.hide(for: self!.view, animated: true)
                
            }
            
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
        
        let (dbErr, user) = self.userDB.getUser()
        if case .SQLError = dbErr {
            print("###########  getUser dbErr  ##############")
            print(dbErr)
        }
        
        getUserProfile(userId: user!.userID)
        
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
                
            }
            
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
        
        let (dbErr, user) = self.userDB.getUser()
        if case .SQLError = dbErr {
            print("###########  getUser dbErr  ##############")
            print(dbErr)
        }
        
        getUserProfile(userId: user!.userID)
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
        
        let (dbErr, user) = self.userDB.getUser()
        if case .SQLError = dbErr {
            print("###########  getUser dbErr  ##############")
            print(dbErr)
        }
        
        let userID: String = (user?.userID)!
        
        let position: Int = (self.superhero?.profilePictures.count)! == 0 ? 1 : (self.superhero?.profilePictures.count)! + 1
        
        self.socket.emit(ConstantRegistry.ON_UPDATE_PROFILE_PICTURE, userID, imageStrBase64, position)
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func configureUI() {
        
        addChild(self.userProfileImagesVC!)
        view.addSubview(self.userProfileImagesVC!.view)
        self.userProfileImagesVC!.didMove(toParent: self)
        self.userProfileImagesVC!.view.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: view.frame.width-10, height: view.frame.height * 0.70)
        self.userProfileImagesVC!.view.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(settingsButton)
        settingsButton.anchor(top: userProfileImagesVC!.view.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 40, width: 60, height: 60)
        
        view.addSubview(addNewProfilePictureButton)
        addNewProfilePictureButton.anchor(top: userProfileImagesVC!.view.bottomAnchor, left: settingsButton.rightAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 30, paddingBottom: 0, paddingRight: 0, width: 60, height: 60)
        
        view.addSubview(editInfoButton)
        editInfoButton.anchor(top: userProfileImagesVC!.view.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 20, width: 60, height: 60)
        
        view.addSubview(infoButton)
        infoButton.anchor(top: userProfileImagesVC!.view.bottomAnchor, left: nil, bottom: nil, right: editInfoButton.leftAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 30, width: 60, height: 60)
        
    }
    
    @objc func editInfoTapped() {
        
        let editProfileInfoVC = EditProfileInfoVC()
        self.navigationController?.pushViewController(editProfileInfoVC, animated: false)
        
    }
    
    @objc func addNewProfilePictureTapped() {
        
        // Configure image picker
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        // present image picker
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    @objc func infoTapped() {
        
        let alert = UIAlertController(title: "Profile Pictures Settings Information", message: "To update existing profile picture tap on the picture and choose another picture. \n\nTo delete existing profile picture tap and hold on the profile picture. \n\nTo add new profile picture, first, close this pop-up, and then tap on the '+' button.", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func settingsTapped() {
        
        let profileSettingsVC = ProfileSettingsVC()
        self.navigationController?.pushViewController(profileSettingsVC, animated: false)
        
    }
    
    func getUserProfile(userId: String!) {
        
        var params = [String: Any]()
        params["superheroId"] = userId
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        self.suggestionProfile = SuggestionProfile()
        self.suggestionProfile!.getSuggestionProfile(params: params) { json, error in
            do {
                
                //Convert to Data
                let jsonData = try JSONSerialization.data(withJSONObject: json!, options: JSONSerialization.WritingOptions.prettyPrinted)
                print("jsonData")
                print(jsonData)
                
                //In production, you usually want to try and cast as the root data structure. Here we are casting as a dictionary. If the root object is an array cast as [Any].
                let suggestionProfileResponse = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? AnyObject
                print("suggestionProfileResponse")
                print(suggestionProfileResponse)
                
                let response = try SuggestionProfileResponse(json: suggestionProfileResponse as! [String : Any])
                print("response")
                print(response)
                
                if response.status != 200 {
                    
                    print("Something went wrong!")
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    return
                }
                
                let layout = UICollectionViewFlowLayout()
                layout.scrollDirection = .horizontal
                self.userProfileImagesVC = UserProfileImagesVC(collectionViewLayout: layout)
                self.userProfileImagesVC!.loadedUser = response.profile
                
                self.configureUI()
                
                self.superhero = response.profile
                
                MBProgressHUD.hide(for: self.view, animated: true)
                
            } catch {
                
                print("catch in getSuggestionProfile")
                MBProgressHUD.hide(for: self.view, animated: true)
                
            }
        }
        
        
    }
    
}
