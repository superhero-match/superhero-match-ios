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

class NoSuggestionsVC: UIViewController {
    
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
    
    let noSuggestionsLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Unfortunately we couldn't find any suggestions based on your profile. Try changing settings or come back later."
        lbl.font = UIFont(name: "Gotham Book", size: 18)
        lbl.textAlignment = .center
        lbl.numberOfLines = 5
        
        return lbl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // background color white
        view.backgroundColor = .white
        
        view.addSubview(logoContainerView)
        logoContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)
        
        view.addSubview(noSuggestionsLabel)
        noSuggestionsLabel.anchor(top: logoContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 100)
    }

}
