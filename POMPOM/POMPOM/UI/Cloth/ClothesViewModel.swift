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
    
    var networkManager: ClothesManager = ClothesManager()
    
    //CouplleView
    
    func requestClothes() async {
        if let defaultCode: String = UserDefaults.standard.string(forKey: "code") {
            networkManager.loadClothes(userCode: defaultCode) { clothes in
                withAnimation {
                    self.selectedItems = clothes
                }
            }
        } else {
            print("DEBUG: 사용자 코드 조회 실패")
        }
    }
    
    func requestPartnerClothes() async {
        if let defaultCode: String = UserDefaults.standard.string(forKey: "partner_code") {
            networkManager.loadClothes(userCode: defaultCode) { clothes in
                    self.selectedItems = clothes
            }
        } else {
            print("DEBUG: 사용자 코드 조회 실패")
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
