//
//  CoupleViewModel.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/06/09.
//

import Foundation
import SwiftUI

enum ClothError: Error {
    case noUserCode
    case networking
}

class ClothesViewModel: ObservableObject {
    //MARK: - Propeties
    @Published var selectedItems: [ClothCategory : Cloth] = [:]
    
    var networkManager: ClothesManager = ClothesManager()
    
    func requestMyClothes(completion: @escaping (Error?) -> Void) {
        if let defaultCode: String = UserDefaults.standard.string(forKey: "code") {
            print("DEBUG: requestMyClothes - userCode \(defaultCode) ")
            networkManager.fetchClohtes(userCode: defaultCode) { result in
                switch result {
                case .success(let loadedItem):
                    self.selectedItems = loadedItem
                    print("DEBUG: requestMyClothes - response \(loadedItem) ")
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
            }
        } else {
            completion(ClothError.noUserCode)
        }
    }
    
    //옷 불러오는 리스너 -> completion 핸들러 필요.
    func addPartnerClothesListenr(completion: @escaping (Error?) -> Void)  {
        if let defaultCode: String = UserDefaults.standard.string(forKey: "partner_code") {
            networkManager.addClothesListner(userCode: defaultCode) { result in
                switch result {
                case .success(let loadedItem):
                    self.selectedItems = loadedItem
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
            }
        } else {
            completion(ClothError.noUserCode)
        }
    }
    
    func clearSelectedItem() {
        for key in selectedItems.keys {
            selectedItems[key] = Cloth(id: " ", hex: " ", category: key) // Firebase 빈문자열 리스너에서 인식 불가 현상. 임시해결🚧
        }
    }
    
    func isValidItem(with category: ClothCategory) -> Bool {
        guard let selectedItem = selectedItems[category] else {
            return false
        }
        
        return selectedItem.id != " " // Firebase 빈문자열 리스너에서 인식 불가 현상. 임시해결🚧
    }
    
    func fetchImageString(with category: ClothCategory) -> String {
        if let name = selectedItems[category]?.id {
            let imageName = "\(category)-\(name)"
            return imageName
        }
        return ""
    }
}
