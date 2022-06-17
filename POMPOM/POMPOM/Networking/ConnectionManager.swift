//
//  ConnectionManager.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/06/09.
//

import Foundation
import FirebaseFirestore

struct ConnectionManager {
    let usersRef = Firestore.firestore().collection("users")
    
    func isExistingCode(code: String) async -> Bool {
        var returnValue: Bool = false
        
        do {
            let querySnapShot = try await usersRef.whereField("code", isEqualTo: code).getDocuments()
            returnValue = querySnapShot.isEmpty ? false : true
        } catch { }
        
        return returnValue
    }
    
    func saveCode(code: String) {
        usersRef.addDocument(data: [
            "code": code,
            "partner_code": ""
        ]) { err in
            if let err = err {
                dump("Error adding users 아래 문서: \(err)")
            }
            print(err)
        }
    }
    
    func updatePartnerCode(oneId: String, anotherCode: String) {
        usersRef.document(oneId).updateData([
            "partner_code": anotherCode
        ]) { err in
            if let err = err {
                print("Error updating users 아래 문서: \(err)")
            }
        }
    }
    
    func deletePartnerCode(oneId: String) {
        usersRef.document(oneId).updateData([
            "partner_code" : ""
        ]) { err in
            if let err = err {
                print("DEBUG: 파트너 코드 삭제 실패")
            }
        }
    }
    
    func getIdByCode(code: String) async -> String {
        var returnValue: String = ""
        
        do {
            let querySnapShot = try await usersRef.whereField("code", isEqualTo: code).getDocuments()
            returnValue = querySnapShot.documents[0].documentID
        } catch { }
        
        return returnValue
    }
}
