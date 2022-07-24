//
//  ClothService.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/07/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class ClothService {
    private let clothesRef = Firestore.firestore().collection("clothes")
    
    func createClothesWith(userCode: String, clothes: Clothes) throws {
        try clothesRef.document(userCode).setData(from: clothes)
    }
    
    func requestClothesWith(userCode: String) async throws -> Clothes {
        let clothes = try await clothesRef.document(userCode).getDocument(as: Clothes.self)
        return clothes
    }
    
    func updateClothesWith(userCode: String, clothes: Clothes) async throws {
        try clothesRef.document(userCode).setData(from: clothes, merge: true)
    }
    
    func deleteClothesWith(userCode: String, clothes: Clothes) async throws {
        try await clothesRef.document(userCode).delete()
    }
}
