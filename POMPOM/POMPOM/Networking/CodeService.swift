//
//  CodeService.swift
//  POMPOM
//
//  Created by 김남건 on 2022/07/24.
//

import Foundation
import FirebaseFirestore

struct CodeService {
    let usersCollection = Firestore.firestore().collection("users")
    
    func isExistingCode(code: String) async throws -> Bool {
        let document = usersCollection.document(code)
        
        return try await document.getDocument().exists
    }
    
    func saveCode(code: String) async throws {
        try await usersCollection.document(code).setData([:])
    }
    
    func updatePartnerCode(myCode: String, partnerCode: String) async throws {
        try await usersCollection.document(myCode).updateData([
            "partner_code": partnerCode
        ])
    }
    
    func deletePartnerCode(myCode: String) async throws {
        try await usersCollection.document(myCode).updateData([
            "partner_code" : FieldValue.delete()
        ])
    }
}
