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

class ProfileImagesSettingsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var longPressMainProfileImageHasBeenHandled: Bool? = false
    var longPressProfileImage1HasBeenHandled: Bool? = false
    var longPressProfileImage2HasBeenHandled: Bool? = false
    var longPressProfileImage3HasBeenHandled: Bool? = false
    var longPressProfileImage4HasBeenHandled: Bool? = false
    var imageIsSelected: Bool? = false
    var currentImageView: Int? = 1
    
    var mainImageUrl: String? {
        didSet {
            mainProfileImageView.image = UIImage(named: mainImageUrl!)
        }
    }
    
    let mainProfileImageView: UIImageView = {
        let piv = UIImageView()
        piv.contentMode = .scaleAspectFill
        piv.layer.cornerRadius = 10
        piv.clipsToBounds = true
        piv.tappable = true
        piv.layer.shadowColor = UIColor.black.cgColor
        piv.layer.shadowOpacity = 1
        piv.layer.shadowOffset = CGSize.zero
        piv.layer.shadowRadius = 10
        piv.layer.shadowPath = UIBezierPath(roundedRect: piv.bounds, cornerRadius: 10).cgPath
        
        return piv
    }()
    
    var profileImage1Url: String? {
        didSet {
            profileImage1View.image = UIImage(named: profileImage1Url!)
        }
    }
    
    let profileImage1View: UIImageView = {
        let piv = UIImageView()
        piv.contentMode = .scaleAspectFill
        piv.layer.cornerRadius = 10
        piv.clipsToBounds = true
        piv.tappable = true
        piv.layer.shadowColor = UIColor.black.cgColor
        piv.layer.shadowOpacity = 1
        piv.layer.shadowOffset = CGSize.zero
        piv.layer.shadowRadius = 10
        piv.layer.shadowPath = UIBezierPath(roundedRect: piv.bounds, cornerRadius: 10).cgPath
        
        return piv
    }()
    
    var profileImage2Url: String? {
        didSet {
            profileImage2View.image = UIImage(named: profileImage2Url!)
        }
    }
    
    let profileImage2View: UIImageView = {
        let piv = UIImageView()
        piv.contentMode = .scaleAspectFill
        piv.layer.cornerRadius = 10
        piv.clipsToBounds = true
        piv.tappable = true
        piv.layer.shadowColor = UIColor.black.cgColor
        piv.layer.shadowOpacity = 1
        piv.layer.shadowOffset = CGSize.zero
        piv.layer.shadowRadius = 10
        piv.layer.shadowPath = UIBezierPath(roundedRect: piv.bounds, cornerRadius: 10).cgPath
        
        let tapped = UITapGestureRecognizer(target: self, action: #selector(handleProfileImage2Tapped))
        piv.addGestureRecognizer(tapped)
        
        let longPressed = UILongPressGestureRecognizer(target: self, action: #selector(handleProfileImage2LongPress))
        piv.addGestureRecognizer(longPressed)
        
        return piv
    }()
    
    var profileImage3Url: String? {
        didSet {
            profileImage3View.image = UIImage(named: profileImage3Url!)
        }
    }
    
    let profileImage3View: UIImageView = {
        let piv = UIImageView()
        piv.contentMode = .scaleAspectFill
        piv.layer.cornerRadius = 10
        piv.clipsToBounds = true
        piv.tappable = true
        piv.layer.shadowColor = UIColor.black.cgColor
        piv.layer.shadowOpacity = 1
        piv.layer.shadowOffset = CGSize.zero
        piv.layer.shadowRadius = 10
        piv.layer.shadowPath = UIBezierPath(roundedRect: piv.bounds, cornerRadius: 10).cgPath
        
        let tapped = UITapGestureRecognizer(target: self, action: #selector(handleProfileImage3Tapped))
        piv.addGestureRecognizer(tapped)
        
        let longPressed = UILongPressGestureRecognizer(target: self, action: #selector(handleProfileImage3LongPress))
        piv.addGestureRecognizer(longPressed)
        
        return piv
    }()
    
    var profileImage4Url: String? {
        didSet {
            profileImage4View.image = UIImage(named: profileImage4Url!)
        }
    }
    
    let profileImage4View: UIImageView = {
        let piv = UIImageView()
        piv.contentMode = .scaleAspectFill
        piv.layer.cornerRadius = 10
        piv.clipsToBounds = true
        piv.tappable = true
        piv.layer.shadowColor = UIColor.black.cgColor
        piv.layer.shadowOpacity = 1
        piv.layer.shadowOffset = CGSize.zero
        piv.layer.shadowRadius = 10
        piv.layer.shadowPath = UIBezierPath(roundedRect: piv.bounds, cornerRadius: 10).cgPath
        
        let tapped = UITapGestureRecognizer(target: self, action: #selector(handleProfileImage4Tapped))
        piv.addGestureRecognizer(tapped)
        
        let longPressed = UILongPressGestureRecognizer(target: self, action: #selector(handleProfileImage4LongPress))
        piv.addGestureRecognizer(longPressed)
        
        return piv
    }()
    
    let uploadImagesBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Upload Images", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.isEnabled = true
        btn.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(handleUploadImages), for: .touchUpInside)
        
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // background color white
        view.backgroundColor = .white
        
        configureMainProfileImage()
        configureProfileImageView1()
        configureProfileImageView2()
        configureProfileImageView3()
        configureProfileImageView4()
        configureUploadImagesBtn()
        
    }
    
    func configureMainProfileImage() {
        
        view.addSubview(mainProfileImageView)
        mainProfileImageView.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 155, height: 155)
        mainProfileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let tapped = UITapGestureRecognizer(target: self, action: #selector(self.handleMainProfileImageTapped))
        
        mainProfileImageView.addGestureRecognizer(tapped)
        
        let longPressed = UILongPressGestureRecognizer(target: self, action: #selector(self.handleMainProfileImageLongPress))
        
        mainProfileImageView.addGestureRecognizer(longPressed)
        
    }
    
    func configureProfileImageView1() {
        
        view.addSubview(profileImage1View)
        profileImage1View.anchor(top: mainProfileImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 145, height: 145)
        
        let tapped = UITapGestureRecognizer(target: self, action: #selector(self.handleProfileImage1Tapped))
        profileImage1View.addGestureRecognizer(tapped)
        
        let longPressed = UILongPressGestureRecognizer(target: self, action: #selector(self.handleProfileImage1LongPress))
        profileImage1View.addGestureRecognizer(longPressed)
        
    }
    
    func configureProfileImageView2() {
        
        view.addSubview(profileImage2View)
        profileImage2View.anchor(top: mainProfileImageView.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 145, height: 145)
        
        let tapped = UITapGestureRecognizer(target: self, action: #selector(self.handleProfileImage2Tapped))
        profileImage2View.addGestureRecognizer(tapped)
        
        let longPressed = UILongPressGestureRecognizer(target: self, action: #selector(self.handleProfileImage2LongPress))
        profileImage2View.addGestureRecognizer(longPressed)
        
    }
    
    func configureProfileImageView3() {
        
        view.addSubview(profileImage3View)
        profileImage3View.anchor(top: profileImage1View.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 145, height: 145)
        
        let tapped = UITapGestureRecognizer(target: self, action: #selector(self.handleProfileImage3Tapped))
        profileImage3View.addGestureRecognizer(tapped)
        
        let longPressed = UILongPressGestureRecognizer(target: self, action: #selector(self.handleProfileImage3LongPress))
        profileImage3View.addGestureRecognizer(longPressed)
        
    }
    
    func configureProfileImageView4() {
        
        view.addSubview(profileImage4View)
        profileImage4View.anchor(top: profileImage2View.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 145, height: 145)
        
        let tapped = UITapGestureRecognizer(target: self, action: #selector(self.handleProfileImage4Tapped))
        profileImage4View.addGestureRecognizer(tapped)
        
        let longPressed = UILongPressGestureRecognizer(target: self, action: #selector(self.handleProfileImage4LongPress))
        profileImage4View.addGestureRecognizer(longPressed)
        
    }
    
    func configureUploadImagesBtn() {
        
        view.addSubview(uploadImagesBtn)
        uploadImagesBtn.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 60, paddingRight: 0, width: 180, height: 60)
        uploadImagesBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Selected image
        guard let profileImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            print("Could not pic the image")
            return
        }
        
        switch self.currentImageView {
        case ConstantRegistry.MAIN_PROFILE_IMAGE_VIEW:
            mainProfileImageView.image = profileImage.withRenderingMode(.alwaysOriginal)
        case ConstantRegistry.FIRST_PROFILE_IMAGE_VIEW:
            profileImage1View.image = profileImage.withRenderingMode(.alwaysOriginal)
        case ConstantRegistry.SECOND_PROFILE_IMAGE_VIEW:
            profileImage2View.image = profileImage.withRenderingMode(.alwaysOriginal)
        case ConstantRegistry.THIRD_PROFILE_IMAGE_VIEW:
            profileImage3View.image = profileImage.withRenderingMode(.alwaysOriginal)
        case ConstantRegistry.FOURTH_PROFILE_IMAGE_VIEW:
            profileImage4View.image = profileImage.withRenderingMode(.alwaysOriginal)
        default:
            print("Incorrect image view number")
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func openImapePicker() {
        
        // Configure image picker
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        // present image picker
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    @objc func handleMainProfileImageTapped() {
        
        print("handleMainProfileImageTapped")
        
        self.currentImageView = 1

        self.longPressMainProfileImageHasBeenHandled = false
        
        openImapePicker()
        
    }
    
    
    @objc func handleMainProfileImageLongPress() {
        
        if !self.longPressMainProfileImageHasBeenHandled! {
            
            print("handleMainProfileImageLongPress")
            self.currentImageView = 1
            mainProfileImageView.image = UIImage(named: "user_profile")
            self.longPressMainProfileImageHasBeenHandled = true
            
        }
        
    }
    
    @objc func handleProfileImage1Tapped() {
        
        print("handleProfileImage1Tapped")
        
        self.currentImageView = 2
        
        self.longPressProfileImage1HasBeenHandled = false
        
        openImapePicker()
        
    }
    
    @objc func handleProfileImage1LongPress() {
        
        if !self.longPressProfileImage1HasBeenHandled! {
            
            print("handleProfileImage1LongPress")
            self.currentImageView = 2
            profileImage1View.image = UIImage(named: "user_profile")
            self.longPressProfileImage1HasBeenHandled = true
            
        }
        
    }
    
    @objc func handleProfileImage2Tapped() {
        
        print("handleProfileImage2Tapped")
        self.currentImageView = 3
        
        self.longPressProfileImage2HasBeenHandled = false
        
        openImapePicker()
        
    }
    
    @objc func handleProfileImage2LongPress() {
        
        if !self.longPressProfileImage2HasBeenHandled! {
            
            print("handleProfileImage2LongPress")
            self.currentImageView = 3
            profileImage2View.image = UIImage(named: "user_profile")
            self.longPressProfileImage2HasBeenHandled = true
            
        }
        
    }
    
    @objc func handleProfileImage3Tapped() {
        
        print("handleProfileImage3Tapped")
        
        self.currentImageView = 4
        
        self.longPressProfileImage3HasBeenHandled = false
        
        openImapePicker()
        
    }
    
    
    @objc func handleProfileImage3LongPress() {
        
        if !self.longPressProfileImage3HasBeenHandled! {
            
            print("handleProfileImage3LongPress")
            self.currentImageView = 4
            profileImage3View.image = UIImage(named: "user_profile")
            self.longPressProfileImage3HasBeenHandled = true
            
        }
        
    }
    
    @objc func handleProfileImage4Tapped() {
        
        print("handleProfileImage4Tapped")
        
        self.currentImageView = 5
        
        self.longPressProfileImage4HasBeenHandled = false
        
        openImapePicker()
        
    }
    
    
    @objc func handleProfileImage4LongPress() {
        
        if !self.longPressProfileImage4HasBeenHandled! {
            
            print("handleProfileImage4LongPress")
            self.currentImageView = 5
            profileImage4View.image = UIImage(named: "user_profile")
            self.longPressProfileImage4HasBeenHandled = true
            
        }
        
    }
    
    @objc func handleUploadImages() {
        
        // Navigate back to SuperheroSuperPowerVC
        _ = navigationController?.popViewController(animated: true)
        
    }
}
