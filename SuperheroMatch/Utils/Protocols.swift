//
//  Protocols.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 18/07/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

protocol ProfileHeaderDelegate {
    func handleSettingsTapped(for header: ProfileHeader)
    func handleEditInfoTapped(for header: ProfileHeader)
    func handleLikeTapped(for header: ProfileHeader)
    func handleDislikeTapped(for header: ProfileHeader)
    func handleProfileDetailsTapped(for header: ProfileHeader)
    func handleProfileImagesTapped(for header: ProfileHeader)
}

protocol SuggestionCellDelegate {
    func handleImageTapped(for cell: SuggestionCell)
    func handleUsernameTapped(for cell: SuggestionCell)
}

protocol Printable {
    var description: String { get }
}

protocol MessageInputAccesoryViewDelegate {
    func handleUploadMessage(message: String)
    func handleSelectImage()
}

protocol ChatCellDelegate {
    func handlePlayVideo(for cell: ChatCell)
}

protocol MessageCellDelegate {
    func configureUserData(for cell: MessageCell)
}
