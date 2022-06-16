//
//  CoupleViewModel.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/06/09.
//

import Foundation

class ClothViewModel: ObservableObject {
    //MARK: - Propeties
    @Published var selectedItems: [ClothCategory : Cloth] = [:]
    
    var networkManager: ClothesManager = ClothesManager()
    
    //CouplleView
    
    func requestClothes() async {
        if let defaultCode: String = UserDefaults.standard.string(forKey: "code") {
            networkManager.loadClothes(userCode: defaultCode) { clothes in
                    self.selectedItems = clothes
            }
        } else {
            print("DEBUG: 사용자 코드 조회 실패")
        }
    }
    
    func clearSelectedItem() {
        selectedItems.removeAll()
    }
    
    func fetchImageString(with category: ClothCategory) -> String {
        if let name = selectedItems[category]?.id {
            let imageName = "\(category)-\(name)"
            return imageName
        }
        return ""
    }
}
