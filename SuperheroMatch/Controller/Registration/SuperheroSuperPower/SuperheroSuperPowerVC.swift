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

class SuperheroSuperPowerVC: UIViewController, UITextViewDelegate {
    
    let superPowerLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "What is your Super Power?"
        lbl.font = UIFont(name: "Gotham Book", size: 22)
        lbl.textAlignment = .center
        lbl.numberOfLines = 2
        
        return lbl
    }()
    
    let superPowerTextView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tv.font = UIFont.systemFont(ofSize: 18)
        
        return tv
    }()
    
    let nextBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Next", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        
        return btn
    }()
    
    let previousBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Previous", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(handlePrevious), for: .touchUpInside)
        
        return btn
    }()
    
    let termsAndPoliciesBtn: UIButton = {
        let btn = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "MWSOFT Copyright 2019.  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Terms & Policies", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)]))
        
        btn.setAttributedTitle(attributedTitle, for: .normal)
        
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // background color white
        view.backgroundColor = .white
        
        // hide nav bar
        navigationController?.navigationBar.isHidden = true
        
        superPowerTextView.delegate = self
        
        configureComponents()
        
        view.addSubview(termsAndPoliciesBtn)
        termsAndPoliciesBtn.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
    }
    
    func configureComponents() {
        
        let stackView = UIStackView(arrangedSubviews: [superPowerLabel, superPowerTextView, nextBtn, previousBtn])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 280)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        guard superPowerTextView.hasText else {
            nextBtn.isEnabled = false
            nextBtn.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
            return
        }
        
        nextBtn.isEnabled = true
        nextBtn.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)

    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let maxLength = 125
        let currentString: NSString = textView.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: text) as NSString
        
        return newString.length <= maxLength
        
    }
    
    @objc func handleNext() {
        
        UserDefaults.standard.set(superPowerTextView.text!, forKey: "superPower")
        UserDefaults.standard.synchronize()
        
        // Navigate to SuperheroProfilePicVC
        let superheroProfilePicVC = SuperheroProfilePicVC()
        navigationController?.pushViewController(superheroProfilePicVC, animated: true)
        
    }
    
    @objc func handlePrevious() {
        
        // Navigate back to SuperheroFavoriteGenderVC
        _ = navigationController?.popViewController(animated: true)
        
    }
    
}
