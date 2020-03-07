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

class SuperheroGenderVC: UIViewController {
    
    var maleFemaleSV: UIStackView!
    var nextPreviousSV: UIStackView!
    
    let superheroGenderLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "What is your gender?"
        lbl.font = UIFont(name: "Gotham Book", size: 22)
        lbl.textAlignment = .center
        lbl.numberOfLines = 2
        
        return lbl
    }()
    
    let maleBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .white
        btn.setTitle("Male", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(handleSelectMale), for: .touchUpInside)
        
        return btn
    }()
    
    let femaleBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .white
        btn.setTitle("Female", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(handleSelectFemale), for: .touchUpInside)
        
        return btn
    }()

    
    let nextBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Next", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        btn.layer.cornerRadius = 5
        btn.isEnabled = false
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
        
        view.addSubview(superheroGenderLabel)
        superheroGenderLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        configureMaleFemale()
        
        configureNextPrevious()
        
        view.addSubview(termsAndPoliciesBtn)
        termsAndPoliciesBtn.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
       
    }
    
    func configureMaleFemale() {
        
        maleFemaleSV = UIStackView(arrangedSubviews: [maleBtn, femaleBtn])
        maleFemaleSV.axis = .horizontal
        maleFemaleSV.spacing = 10
        maleFemaleSV.distribution = .fillEqually
        
        view.addSubview(maleFemaleSV)
        maleFemaleSV.anchor(top: superheroGenderLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 50, paddingBottom: 0, paddingRight: 50, width: 220, height: 100)
        maleFemaleSV.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func configureNextPrevious() {
        
        nextPreviousSV = UIStackView(arrangedSubviews: [nextBtn, previousBtn])
        nextPreviousSV.axis = .vertical
        nextPreviousSV.spacing = 10
        nextPreviousSV.distribution = .fillEqually
        
        view.addSubview(nextPreviousSV)
        nextPreviousSV.anchor(top: maleFemaleSV.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 100)
    }
    
    @objc func handleNext() {
        
        // Navigate to SuperheroFavoriteGenderVC
        let superheroFavoriteGenderVC = SuperheroFavoriteGenderVC()
        navigationController?.pushViewController(superheroFavoriteGenderVC, animated: true)
        
    }
    
    @objc func handlePrevious() {
        
        // Navigate back to SuperheroDistanceUnitVC
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    @objc func handleSelectMale() {
        
        // Configure buttons
        maleBtn.setTitleColor(.white, for: .normal)
        maleBtn.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        
        femaleBtn.setTitleColor(.black, for: .normal)
        femaleBtn.backgroundColor = .white
        
        // Enable next button
        nextBtn.isEnabled = true
        nextBtn.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        
        UserDefaults.standard.set(1, forKey: "gender")
        UserDefaults.standard.synchronize()
        
    }
    
    @objc func handleSelectFemale() {
        
        // Configure buttons
        femaleBtn.setTitleColor(.white, for: .normal)
        femaleBtn.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        
        maleBtn.setTitleColor(.black, for: .normal)
        maleBtn.backgroundColor = .white
        
        // Enable next button
        nextBtn.isEnabled = true
        nextBtn.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        
        UserDefaults.standard.set(2, forKey: "gender")
        UserDefaults.standard.synchronize()
        
    }
    

}
