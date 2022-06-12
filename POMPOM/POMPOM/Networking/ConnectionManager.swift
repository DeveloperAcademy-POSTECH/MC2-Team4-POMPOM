//
//  ConnectionManager.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/06/09.
//

import Foundation
import FirebaseFirestore

struct ConnectionManager {
    static private let usersRef = Firestore.firestore().collection("users")
    
    static func saveCode(code: String){
        usersRef.addDocument(data: [
            "code": code
        ]) { err in
            if let err = err {
                dump("Error adding users 아래 문서: \(err)")
            }
        }
    }
}
