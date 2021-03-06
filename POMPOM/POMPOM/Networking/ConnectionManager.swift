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
                dump("Error adding users μλ λ¬Έμ: \(err)")
                print("DEBUG: ConnectionManager - \(err.localizedDescription)")
            }
        }
    }
    
    func updatePartnerCode(oneId: String, anotherCode: String) {
        usersRef.document(oneId).updateData([
            "partner_code": anotherCode
        ]) { err in
            if let err = err {
                print("DEBUG: ConnectionManager - \(err)")
            }
        }
    }
    
    func deletePartnerCode(oneId: String) {
        usersRef.document(oneId).updateData([
            "partner_code" : ""
        ]) { err in
            if let err = err {
                print("DEBUG: ConnectionManager - \(err.localizedDescription)")
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
    
    func updatePartnerCodeBy(ownCode: String) async {
        do {
            try await usersRef.document(getIdByCode(code: ownCode))
            .updateData(["partner_code": " "])
        } catch {
            print("cannot get document by code")
        }
    }
}
