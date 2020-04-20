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

protocol ProfileHeaderDelegate {
    func handleSettingsTapped(for header: ProfileHeader)
    func handleEditInfoTapped(for header: ProfileHeader)
    func handleLikeTapped(for header: ProfileHeader)
    func handleDislikeTapped(for header: ProfileHeader)
    func handleProfileDetailsTapped(for header: ProfileHeader)
    func handleProfileImagesTapped(for header: ProfileHeader)
}

protocol SuggestionCellDelegate {
//    func handleImageTapped(for cell: SuggestionCell)
//    func handleUsernameTapped(for cell: SuggestionCell)
}

protocol Printable {
    var description: String { get }
}

protocol MessageInputAccesoryViewDelegate {
    func handleUploadMessage(message: String)
}

protocol MessageCellDelegate {
    func configureUserData(for cell: MessageCell)
}
