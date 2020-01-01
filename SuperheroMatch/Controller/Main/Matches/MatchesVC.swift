//
//  MatchesVC.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 18/07/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MatchesTableViewCell"

class MatchesVC: UITableViewController {
    
    var chats : [Chat] = []
    let chatDB = ChatDB.sharedDB
    var uploadMatch: UploadMatch?
    var deleteMatch: DeleteMatch?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 100
        
        loadChats()
        
        tableView.register(MatchesTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        constructNavigationController()
        
        setupLongPressGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        loadChats()
        
        self.tableView.reloadData()
    }
    
    func loadChats() {
        
        let (err, result) = self.fetchChats()
        if case .SQLError = err {
            print("###########  getAllChats err  ##############")
            print(err)
            
            return
        }
        
        self.chats = result
        
    }
    
    func setupLongPressGesture() {
        let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 1.0
        self.tableView.addGestureRecognizer(longPressGesture)
    }
    
    func configureDeleteMatchRequestParameters(matchId: String!) -> [String: Any] {
        
        var params = [String: Any]()
        
        params["id"] = matchId
        
        return params
        
    }
    
    func deleteMatch(params: [String: Any]) {
        
        self.deleteMatch = DeleteMatch()
        self.deleteMatch!.deleteMatch(params: params) { json, error in
            do {
                
                //Convert to Data
                let jsonData = try JSONSerialization.data(withJSONObject: json!, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                //In production, you usually want to try and cast as the root data structure. Here we are casting as a dictionary. If the root object is an array cast as [Any].
                let deleteMatchResponse = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? AnyObject
                
                let response = deleteMatchResponse as! [String : Int]
                
                if response["status"] != 200  {
                    print("Error!")
                    
                    return
                }
                
            } catch {
                // TO-DO: Show alert that something went wrong
                print("catch in deleteMatch")
            }
        }
        
    }
    
    func showDeleteMatchAlert(matchId: String!, index: Int!) {
        let alert = UIAlertController(title: "Delete match?", message: "", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.default, handler: { _ in
            let (err, _) = self.chatDB.deleteChatById(chatId: matchId)
            if case .SQLError = err {
                print("###########  deleteChatById err  ##############")
                print(err)
                
                return
            }
            
            let params = self.configureDeleteMatchRequestParameters(matchId: matchId)
            self.deleteMatch(params: params)
            
            self.chats.remove(at: index)
            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            // Don't delete
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                let chat = self.chats[indexPath.row]
                
                self.showDeleteMatchAlert(matchId: chat.chatID, index: indexPath.row)
                
            }
        }
    }
    
    func constructNavigationController() {
        self.navigationItem.title = "Matches"
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MatchesTableViewCell
        
        cell.chat = self.chats[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        //        let messagesController = MessagesVC()
        // messagesController.chat = chats[indexPath.row]
        //        navigationController?.pushViewController(messagesController, animated: true)
        
        let chatController = ChatController(collectionViewLayout: UICollectionViewFlowLayout())
        chatController.chat = chats[indexPath.row]
        navigationController?.pushViewController(chatController, animated: true)
    }
    
    func fetchChats() -> (DBError, Array<Chat>) {
        
        let (dbErr, result) = self.chatDB.getAllChats()
        if case .SQLError = dbErr {
            return (dbErr, result)
        }
        
        return (dbErr, result)
        
    }
    
}
