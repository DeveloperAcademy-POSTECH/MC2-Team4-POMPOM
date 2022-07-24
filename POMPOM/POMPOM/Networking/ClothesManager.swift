//
//  ClothesManager.swift
//  POMPOM
//
//  Created by ICHAN NAM on 2022/06/15.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
//
//struct ClothesManager {
//    let clothesRef = Firestore.firestore().collection("clothes")
//
//    // 옷 저장 딕셔너리 형태로 저장.
//    func saveClothes(userCode: String, clothes: [ClothCategory: Cloth]) {
//        clothesRef.document(userCode).setData(parseClothes(clothes: clothes))
//    }
//
//    // Cloth 인코딩 메서드
//    func parseClothes(clothes: [ClothCategory: Cloth]) -> [String: Any] {
//        var returnValue: [String: Any] = [:]
//
//        for clothCategory in ClothCategory.allCases {
//            if let cloth = clothes[clothCategory] {
//                returnValue[clothCategory.rawValue] = [ cloth.id, cloth.hex ]
//            } else {
//                returnValue[clothCategory.rawValue] = [ "", "" ]
//            }
//        }
//
//        return returnValue
//    }
//
//    // Cloth 를 코드로 불러옴. (파싱까지 해서)
//    func loadClothes(userCode: String, competion: @escaping ([ClothCategory : Cloth]) -> Void) {
//        var returnValue: [ClothCategory: Cloth] = [:]
//
//
//        clothesRef.document(userCode).addSnapshotListener { snapShot, error in
//            guard let data = snapShot?.data() else { competion(returnValue)
//                return
//            }
//
//            print("Here is listener")
//
//            switch error {
//            case .none:
//                for clothCategory in ClothCategory.allCases {
//                    if let cloth: [String] = data[clothCategory.rawValue] as! [String]? {
//                        if !(cloth[0].isEmpty && cloth[1].isEmpty) {
//                            returnValue[clothCategory] = Cloth(id: cloth[0], hex: cloth[1], category: clothCategory)
//                        }
//                    }
//                }
//                competion(returnValue)
//            case .some(let error):
//                print("DEBUG: 옷 불러오기 에러 - \(error)")
//            }
//
//        }
//    }
//}

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



enum CodeError: Error {
    case noLocalCode
    case invalidCode
}
