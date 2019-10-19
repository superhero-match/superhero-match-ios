//
//  EditProfileInfoVC.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 19/10/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit

class EditProfileInfoVC: UIViewController, UITextFieldDelegate {
    
    var kmMiSV: UIStackView!
    var superPowerSV: UIStackView!
    
    let superPowerLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "What is your Super Power?"
        lbl.font = UIFont(name: "Gotham Book", size: 22)
        lbl.textAlignment = .center
        lbl.numberOfLines = 2
        
        return lbl
    }()
    
    let superPowerTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Your Super Power..."
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleValueChanged), for: .editingChanged)
        
        return tf
    }()
    
    let superheroDistanceUnitLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Distance Unit"
        lbl.font = UIFont(name: "Gotham Book", size: 22)
        lbl.textAlignment = .center
        lbl.numberOfLines = 2
        
        return lbl
    }()
    
    let kmBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Kilometers", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(handleSelectKm), for: .touchUpInside)
        
        return btn
    }()
    
    let miBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Miles", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(handleSelectMi), for: .touchUpInside)
        
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // background color white
        view.backgroundColor = .white
        
        superPowerTextField.delegate = self
        
        configureSuperPower()
        
        configureKmMi()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func configureSuperPower() {
        
        superPowerSV = UIStackView(arrangedSubviews: [superPowerLabel, superPowerTextField])
        superPowerSV.axis = .vertical
        superPowerSV.spacing = 10
        superPowerSV.distribution = .fillEqually
        
        view.addSubview(superPowerSV)
        superPowerSV.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 280)
        
    }
    
    func configureKmMi() {
        
        view.addSubview(superheroDistanceUnitLabel)
        superheroDistanceUnitLabel.anchor(top: superPowerSV.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        kmMiSV = UIStackView(arrangedSubviews: [kmBtn, miBtn])
        kmMiSV.axis = .horizontal
        kmMiSV.spacing = 10
        kmMiSV.distribution = .fillEqually
        
        view.addSubview(kmMiSV)
        kmMiSV.anchor(top: superheroDistanceUnitLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 50, paddingBottom: 0, paddingRight: 50, width: 260, height: 80)
        kmMiSV.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let maxLength = 125
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        
        return newString.length <= maxLength
        
    }
    
    @objc func handleValueChanged() {
        
        guard superPowerTextField.hasText else {
            
            // TO-DO: save to local db
            
            return
        }
        
    }
    
    @objc func handleSelectKm() {
        
        // Configure buttons
        kmBtn.setTitleColor(.white, for: .normal)
        kmBtn.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        
        miBtn.setTitleColor(.black, for: .normal)
        miBtn.backgroundColor = .white
        
        // TO-DO: save to local db
        
    }
    
    @objc func handleSelectMi() {
        
        // Configure buttons
        kmBtn.setTitleColor(.black, for: .normal)
        kmBtn.backgroundColor = .white
        
        miBtn.setTitleColor(.white, for: .normal)
        miBtn.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        
        // TO-DO: save to local db
        
    }
    
}
