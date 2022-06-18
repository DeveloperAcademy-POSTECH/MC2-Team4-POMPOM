//
//  ClothesManager.swift
//  POMPOM
//
//  Created by ICHAN NAM on 2022/06/15.
//

import Foundation
import FirebaseFirestore



struct ClothesManager {
    let clothesRef = Firestore.firestore().collection("clothes")
    
    //옷을 업로드 하는 메서드
    func setClothes(userCode: String, clothes: [ClothCategory: Cloth], completion: @escaping (Result<Void, Error>) -> Void) {
        clothesRef.document(userCode).setData(parse(clothes: clothes)) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    
    //한번만 옷을 불러오는 메서드
    func fetchClohtes(userCode: String, completion: @escaping (Result<[ClothCategory: Cloth], Error>) -> Void) {
        var returnValue: [ClothCategory: Cloth] = [:]
        
        clothesRef.document(userCode).getDocument { snapShot, error in
            guard let data = snapShot?.data() else {
                completion(.success(returnValue))
                return
            }
            
            switch error {
            case .none:
                for clothCategory in ClothCategory.allCases {
                    if let cloth: [String] = data[clothCategory.rawValue] as! [String]? {
                        if !(cloth[0].isEmpty && cloth[1].isEmpty) {
                            returnValue[clothCategory] = Cloth(id: cloth[0], hex: cloth[1], category: clothCategory)
                        }
                    }
                }
                completion(.success(returnValue))
            case .some(let error):
                completion(.failure(error))
            }
        }
    }
    
    //옷이 변경됨을 관찰하는 리스너를 붙이는 메서드
    func addClothesListner(userCode: String, completion: @escaping (Result<[ClothCategory : Cloth], Error>) -> Void) {
        var returnValue: [ClothCategory: Cloth] = [:]
        
        clothesRef.document(userCode).addSnapshotListener { snapShot, error in
            guard let data = snapShot?.data() else {
                completion(.success(returnValue))
                return
            }

            switch error {
            case .none:
                for clothCategory in ClothCategory.allCases {
                    if let cloth: [String] = data[clothCategory.rawValue] as! [String]? {
                        if !(cloth[0].isEmpty && cloth[1].isEmpty) {
                            returnValue[clothCategory] = Cloth(id: cloth[0], hex: cloth[1], category: clothCategory)
                        }
                    }
                }
                completion(.success(returnValue))
            case .some(let error):
                completion(.failure(error))
            }
        }
    }
    
    //MARK: - Private Helpers
    
    private func parse(clothes: [ClothCategory: Cloth]) -> [String: Any] {
        var returnValue: [String: Any] = [:]
        
        for clothCategory in ClothCategory.allCases {
            if let cloth = clothes[clothCategory] {
                returnValue[clothCategory.rawValue] = [ cloth.id, cloth.hex ]
            } else {
                returnValue[clothCategory.rawValue] = [ "", "" ]
            }
        }
        
        return returnValue
    }
}
