//
//  Message.swift
//  POMPOM
//
//  Created by jiin on 2022/06/16.
//

import SwiftUI
import FirebaseFirestore

class messageData: ObservableObject{
    @Published var messages: [Message] = []
    let reference = Firestore.firestore()
    
    init() {
        readMessages()
    }
    
    func readMessages() {
        let myCode = CodeManager().getCode()
        reference.collection("message").order(by: "timestamp", descending: false).addSnapshotListener {
            (snap, err) in
            
            if let error = err{
                print(error.localizedDescription)
                return
            }
            
            guard let data = snap else { return }
            
            data.documentChanges.forEach { change in
                
                if change.type == .added {
                    if (change.document.get("messageFrom") as? String ?? "" == myCode || change.document.get("messageTo") as? String ?? "" == myCode) {
                        let newMsg: Message = Message(_id : change.document.get("id") as? Int ?? 0,
                                                      _messageContent: change.document.get("messageContent") as? String ?? "",
                                                      _messageFrom: change.document.get("messageFrom") as? String ?? "",
                                                      _messageTo: change.document.get("messageTo") as? String ?? "",
                                                      _timestamp: (change.document.get("timestamp") as! Timestamp).dateValue())
                        self.messages.append(newMsg)
                    }

                }
            }
        }
    }
}


struct Message: Codable, Identifiable, Hashable {
    let id: Int
    let messageContent: String
    let messageFrom: String
    let messageTo: String
    let timestamp: Date
    
    init(_id: Int, _messageContent: String, _messageFrom: String, _messageTo: String, _timestamp: Date) {
        id = _id
        messageContent = _messageContent
        messageFrom = _messageFrom
        messageTo = _messageTo
        timestamp = _timestamp
    }
}
