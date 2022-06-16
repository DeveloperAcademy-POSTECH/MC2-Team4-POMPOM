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
    
    init(){
        readMessages()
    }
    
    func readMessages() {
        reference.collection("message").order(by: "timestamp",descending: false).addSnapshotListener{
            (snap, err) in
            
            if err != nil{
                print(err!.localizedDescription)
                return
            }
            
            guard let data = snap else {return}
            
            data.documentChanges.forEach { (change) in
                
                let timestampp = change.document.get("timestamp") as! Timestamp
                print("timestamp is \(timestampp.dateValue())")
                
                if change.type == .added {
                    let newMsg: Message = Message(_id : change.document.get("id") as! Int, _messageContent: change.document.get("messageContent") as! String, _messageFrom: change.document.get("messageFrom") as! String, _messageTo: change.document.get("messageTo") as! String, _timestamp: (change.document.get("timestamp") as! Timestamp).dateValue()) //가드 안됐음
                    self.messages.append(newMsg)
                }
            }
        }
    }
}


struct Message: Codable, Identifiable, Hashable {
    var id: Int
    var messageContent: String
    var messageFrom: String
    var messageTo: String
    var timestamp: Date
    
    init(_id: Int, _messageContent: String, _messageFrom: String, _messageTo: String, _timestamp: Date) {
        id = _id
        messageContent = _messageContent
        messageFrom = _messageFrom
        messageTo = _messageTo
        timestamp = _timestamp
    }
}
