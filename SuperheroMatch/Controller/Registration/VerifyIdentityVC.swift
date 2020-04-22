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
import GoogleSignIn
import MBProgressHUD

class VerifyIdentityVC: UIViewController, GIDSignInUIDelegate {
    
    var checkEmail: CheckEmail?
    let userDB = UserDB.sharedDB

    let logoContainerView: UIView = {
        let view = UIView()
        let logo = UIImageView(image: UIImage(named: "logo"))
        logo.contentMode = .scaleAspectFill
        view.addSubview(logo)
        logo.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 125, height: 125)
        logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logo.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        return view
    }()
    
    let verifyIdentityLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Verify Your Superhero Identity"
        lbl.font = UIFont(name: "Gotham Book", size: 22)
        lbl.textAlignment = .center
        lbl.numberOfLines = 2
        
        return lbl
    }()
    
    let googleSignIn: GIDSignInButton = {
        let btn =  GIDSignInButton()
        
        return btn
    }()
    
    let termsAndPoliciesBtn: UIButton = {
        let btn = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "MWSOFT Copyright 2019.  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Terms & Policies", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)]))
        
        btn.setAttributedTitle(attributedTitle, for: .normal)
        
        btn.addTarget(self, action: #selector(handleShowTermsAndPolicies), for: .touchUpInside)
        
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // background color white
        view.backgroundColor = .white
        
        // hide nav bar
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(logoContainerView)
        logoContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        
        configureComponents()
        
        view.addSubview(termsAndPoliciesBtn)
        termsAndPoliciesBtn.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(didSignIn), name: NSNotification.Name("SuccessfulSignInNotification"), object: nil)
        
    }
    
    func configureComponents() {
        
        let stackView = UIStackView(arrangedSubviews: [verifyIdentityLabel, googleSignIn])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: logoContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 100)
    }
    
    @objc func handleGoogleSignIn() {
        print("handleGoogleSignIn has been called")
        GIDSignIn.sharedInstance().signIn()
    }
    
    @objc func handleShowTermsAndPolicies() {
        print("handleShowTermsAndPolicies")
    }
    
    @objc func didSignIn()  {
        
        let email = UserDefaults.standard.string(forKey: "email") ?? ""
        
        self.checkEmail = CheckEmail()
        self.checkEmailRegistered(checkEmail: self.checkEmail!, email: email)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func checkEmailRegistered(checkEmail: CheckEmail, email: String) {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        checkEmail.checkEmail(email: email) { json, error in
            do {
                
                MBProgressHUD.hide(for: self.view, animated: true)
                
                //Convert to Data
                print("before jsonData")
                let jsonData = try JSONSerialization.data(withJSONObject: json!, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                //In production, you usually want to try and cast as the root data structure. Here we are casting as a dictionary. If the root object is an array cast as [Any].
                print("before checkEmailResponse")
                let checkEmailResponse = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? AnyObject
                
                print("before response")
                let response = try CheckEmailResponse(json: checkEmailResponse as! [String : Any])
                
                if !response.isRegistered {
                    let superheroNameVC = SuperheroNameVC()
                    self.navigationController?.pushViewController(superheroNameVC, animated: true)
                } else if response.isDeleted || response.isBlocked {
                    self.showDeletedOrBlockedAlert()
                } else {
                    let (uerr, userId) = self.userDB.getUserId()
                    if case .SQLError = uerr {
                        print("###########  getUserId uerr  ##############")
                        print(uerr)
                    }
                    
                    // User is already registered, save to local db.
                    if userId == "default" || userId != nil {
                        // This means that the default user is in the db.
                        // So, in this case use update method.
                        let (err, changes) = self.userDB.updateDefaultUser(user: response.superhero!)
                        if case .SQLError = err {
                            print("###########  updateDefaultUser err  ##############")
                            print(err)
                        }
                        
                        print("###########  updateDefaultUser changes  ##############")
                        print(changes)
                    } else {
                        // This means that the default user is not in db yet.
                        // So, in this case insert new user.
                        let (err, changes) = self.userDB.insertUser(user: response.superhero!)
                        if case .SQLError = err {
                            print("###########  insertUser err  ##############")
                            print(err)
                        }
                        
                        print("###########  insertUser changes  ##############")
                        print(changes)
                    }
                    
                    self.navigationController?.dismiss(animated: false, completion: { () -> Void in
                        DispatchQueue.global(qos: .background).async {

                            // Background Thread

                            DispatchQueue.main.async {
                                // Run UI Updates
                                let mainTabVC = MainTabVC()
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.window?.rootViewController! = mainTabVC
                            }
                        }
                    })

                }
                
            } catch {
                print("catch")
            }
        }
        
    }
    
    func showDeletedOrBlockedAlert() {
        
        let alert = UIAlertController(title: "Something is wrong with your account", message: "Please get in touch with our customer support", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
