//
//  VerifyIdentityVC.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 17/07/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class VerifyIdentityVC: UIViewController, GIDSignInUIDelegate {
    
    var checkEmail: CheckEmail?
    
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
        
        checkEmail.checkEmail(email: email) { json, error in
            do {
                
                //Convert to Data
                let jsonData = try JSONSerialization.data(withJSONObject: json!, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                //In production, you usually want to try and cast as the root data structure. Here we are casting as a dictionary. If the root object is an array cast as [Any].
                let checkEmailResponse = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? AnyObject
                
                let response = try CheckEmailResponse(json: checkEmailResponse as! [String : Any])

                if !response.registered! {
                    let superheroNameVC = SuperheroNameVC()
                    self.navigationController?.pushViewController(superheroNameVC, animated: true)
                } else {
                    let mainTabVC = MainTabVC()
                    self.present(mainTabVC, animated: true, completion: nil)
                }
                
            } catch {
                print("catch")
            }
        }
        
    }

}
