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

import Foundation

class Invite {
    
    var networkManager: NetworkManager
    
    init() {
        self.networkManager = NetworkManager()
    }
    
    func inviteUser(userName: String!, inviteeName: String!, inviteeEmail: String!, closure: @escaping (_ json: Any?, _ error: Error?)->()) {
        self.networkManager.loadUrl(
            url: ConstantRegistry.BASE_SERVER_URL + ConstantRegistry.SUPERHERO_INVITE_PORT + "/api/v1/superhero_invite/invite_user?userName=\(userName!)&inviteeName=\(inviteeName!)&inviteeEmail=\(inviteeEmail!)",
            params: nil,
            method: .post,
            encoding: nil
        ) { json, error in
            closure(json, error)
        }
    }
    
}
