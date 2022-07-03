//
//  CoupleViewModel.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/06/09.
//

import Combine
import SwiftUI

final class ClothViewModel: ObservableObject {
    @Published private(set) var hex: String = "FFFFFF"
    @Published private(set) var mainImageString: String = ""
    @Published private(set) var strokeIamgeString: String = ""
    @Published private(set) var strokeHex: String = "000000"
    @Published private(set) var isEmpty: Bool = true
    let category: ClothCategory
    
    private let clothSubject = CurrentValueSubject<Cloth?, Never>(nil)
    private var cancellables = Set<AnyCancellable>()
    
    init(cloth: Cloth?, category: ClothCategory) {
        self.category = category
        
        let clothSharedPublisher = clothSubject
            .compactMap { $0 }
            .share()
        
        clothSharedPublisher
            .map(\.hex)
            .removeDuplicates()
            .assign(to: \.hex, on: self)
            .store(in: &cancellables)
        
        clothSharedPublisher
            .map(\.hex)
            .removeDuplicates()
            .map { hex in
                // //MARK: 옷 색에 따라 테두리 색을 바꿔주는 map 필요
                if hex == "000000" {
                    return "DADADA"
                } else {
                    return "121212"
                }
            }
            .assign(to: \.strokeHex, on: self)
            .store(in: &cancellables)
        
        clothSharedPublisher
            .map(\.id)
            .removeDuplicates()
            .sink { id in
                if !id.isEmpty && id != " " {
                    self.mainImageString = "\(category)-\(id)B"
                    self.strokeIamgeString = "\(category)-\(id)"
                }
            }
            .store(in: &cancellables)
        
        if let cloth = cloth {
            clothSubject.send(cloth)
        }
    }
}

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
