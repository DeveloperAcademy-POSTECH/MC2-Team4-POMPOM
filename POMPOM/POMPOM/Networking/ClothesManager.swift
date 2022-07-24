//
//  ClothesManager.swift
//  POMPOM
//
//  Created by ICHAN NAM on 2022/06/15.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class ClothesManagerTest {
    private let clothService = ClothService()
    
    func requestMyClothes() async throws -> Clothes {
        guard let myCode = UserDefaults.standard.string(forKey: "code") else {
            throw CodeError.noLocalCode
        }
        let clothes = try await clothService.requestClothesWith(userCode: myCode)
        return clothes
    }
    
    func updateMyClothes(clothes: Clothes) async throws {
        guard let myCode = UserDefaults.standard.string(forKey: "code") else {
            throw CodeError.noLocalCode
        }
        try await clothService.updateClothesWith(userCode: myCode, clothes: clothes)
    }
    
    func addClothesListener(code: String, completion: @escaping (Clothes?, Error?) -> Void) {
        let clothRef = Firestore.firestore().collection("clothes")
        
        clothRef.document(code).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                completion(nil, error)
                return
            }
            var clothes: Clothes = Clothes(items: [:])
            do {
                clothes = try document.data(as: Clothes.self)
            } catch {
                var returnValue: [ClothCategory: Cloth] = [:]
                for clothCategory in ClothCategory.allCases {
                    if let cloth: [String] = document.data()?[clothCategory.rawValue] as! [String]? {
                        if !(cloth[0].isEmpty && cloth[1].isEmpty) {
                            returnValue[clothCategory] = Cloth(id: cloth[0], hex: cloth[1], category: clothCategory)
                        }
                    }
                }
            }
            completion(clothes, nil)
        }
    }
}



