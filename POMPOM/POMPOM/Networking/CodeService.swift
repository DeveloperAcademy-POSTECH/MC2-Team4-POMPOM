//
//  CodeService.swift
//  POMPOM
//
//  Created by 김남건 on 2022/07/24.
//

import Foundation
import FirebaseFirestore

struct CodeService {
    static let shared = CodeService()
    
    private init() {}
    
    let usersCollection = Firestore.firestore().collection("users")
    
    func isExistingCode(code: String) async throws -> Bool {
        let document = usersCollection.document(code)
        
        return try await document.getDocument().exists
    }
    
    func saveCode(code: String) async throws {
        try await usersCollection.document(code).setData([:])
    }
    
    func updatePartnerCode(myCode: String, partnerCode: String) async throws -> Bool {
        try await usersCollection.document(myCode).updateData([
            "partner_code": partnerCode
        ])
        
        return true // async let 사용 위해 dummy return 값 부여
    }
    
    func deletePartnerCode(in myCode: String) async throws -> Bool {
        try await usersCollection.document(myCode).updateData([
            "partner_code" : FieldValue.delete()
        ])
        
        return true // async let 사용 위해 dummy return 값 부여
    }
}
