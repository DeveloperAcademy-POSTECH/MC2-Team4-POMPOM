//
//  CoupleViewModel.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/06/09.
//

import Combine
import SwiftUI

class ClothesViewModel: ObservableObject {
    //MARK: - Propeties
    @Published var selectedItems: [ClothCategory : Cloth] = [:]
//    @Published var selectedClothes: Clothes = Clothes()
    
    var networkManager: ClothesManagerTest = ClothesManagerTest()
    
    //CouplleView
    
    func requestClothes() async throws {
        let clothes = try await networkManager.requestMyClothes()
        selectedItems = clothes.items
      
    }
    
    func listenPartnerClothes() {
        guard let partnerCode = UserDefaults.standard.string(forKey: "partner_code") else { return }
        networkManager.addClothesListener(code: partnerCode) { clothes, error in
            if let error = error {
                print("ERROR: addListenerToPartner - \(error.localizedDescription)")
            } else {
                if let clothes = clothes {
                    self.selectedItems = clothes.items
                    
                }
            }
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
