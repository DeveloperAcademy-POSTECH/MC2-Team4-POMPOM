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
    
    func saveClothes(userCode: String, clothes: [ClothCategory: Cloth]) {
        clothesRef.document(userCode).setData(parseClothes(clothes: clothes))
    }
    
    func parseClothes(clothes: [ClothCategory: Cloth]) -> [String: Any] {
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
    
    func loadClothes(userCode: String, competion: @escaping ([ClothCategory : Cloth]) -> Void) {
        var returnValue: [ClothCategory: Cloth] = [:]
        
        clothesRef.document(userCode).addSnapshotListener { snapShot, error in
            guard let data = snapShot?.data() else { competion(returnValue)
                return
            }
            
            print("Here is listener")

            switch error {
            case .none:
                for clothCategory in ClothCategory.allCases {
                    if let cloth: [String] = data[clothCategory.rawValue] as! [String]? {
                        if !(cloth[0].isEmpty && cloth[1].isEmpty) {
                            returnValue[clothCategory] = Cloth(id: cloth[0], hex: cloth[1], category: clothCategory)
                        }
                    }
                }
                competion(returnValue)
            case .some(let error):
                print("DEBUG: 옷 불러오기 에러 - \(error)")
            }
            
        }
    }
}
