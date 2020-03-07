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

class ItIsAMatchVC: UIViewController {
    
    var mainImageUrl: String? {
        didSet {
            mainProfileImageView.image = UIImage(named: mainImageUrl!)
        }
    }
    
    let mainProfileImageView: UIImageView = {
        let piv = UIImageView()
        piv.contentMode = .scaleAspectFill
        piv.clipsToBounds = true
        piv.tappable = true
        
        return piv
    }()
    
    let itIsAMatchLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "It's a match!"
        lbl.font = UIFont(name: "Gotham Book", size: 42)
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.numberOfLines = 1
        
        return lbl
    }()
    
    lazy var chatNowButton: UIButton = {
        var btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "chat_match")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(handleChatNowBtn), for: .touchUpInside)
        
       return btn
    }()
    
    let delimiterView: UIView = {
        var uv = UIView()
        
        return uv
    }()
    
    lazy var chatLaterButton: UIButton = {
        var btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "match_ok")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(handleChatLaterBtn), for: .touchUpInside)
        
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // background color white
        view.backgroundColor = .white
        
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = true

        view.addSubview(mainProfileImageView)
        mainProfileImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: view.frame.height)
        
        view.addSubview(itIsAMatchLabel)
        itIsAMatchLabel.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 150, paddingRight: 0, width: 0, height: 50)
        itIsAMatchLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(delimiterView)
        delimiterView.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 50, paddingRight: 30, width: 1, height: 1)
        delimiterView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(chatNowButton)
        chatNowButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: delimiterView.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 50, paddingRight: 30, width: 75, height: 75)
        
        view.addSubview(chatLaterButton)
        chatLaterButton.anchor(top: nil, left: delimiterView.rightAnchor, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 30, paddingBottom: 50, paddingRight: 0, width: 75, height: 75)
        
    }

    @objc func handleChatNowBtn() {
        
        navigationController?.isNavigationBarHidden = false
        
        tabBarController?.tabBar.isHidden = false
        tabBarController?.selectedIndex = 1
        
        _ = navigationController?.popViewController(animated: true)
        
    }

    @objc func handleChatLaterBtn() {
        
        navigationController?.isNavigationBarHidden = false
        
        tabBarController?.tabBar.isHidden = false
        
        _ = navigationController?.popViewController(animated: true)
        
    }
}
