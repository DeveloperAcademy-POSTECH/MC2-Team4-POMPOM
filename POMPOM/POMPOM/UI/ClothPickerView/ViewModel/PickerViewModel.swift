//
//  PickerViewModel.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/06/13.
//

import SwiftUI

class PickerViewModel: ObservableObject {
    //MARK: - Propeties
    @Published var currentType: ClothCategory = .hat
    @Published var currentPresets: [String] = []
    @Published var currentItems: [String] = []
    @Published var selectedItems: [ClothCategory : Cloth] = [:]
    
    
    // presets 이차원 배열 key : ClothCategory , value -> [String]
    var presets: [ClothCategory : [String]] = [
        .hat : ["FFFFFF", "000000", "325593", "2E614E", "AD5139", "DF002B"],
        .top : ["FFFFFF", "000000", "BAD2F5", "C5C5C7", "23293F", "00914E", "3F2D24", "32323B"],
        .bottom : ["FFFFFF", "C5C5C7", "ACC8E0", "1D2433", "FAF3E6", "CBAF86", "6D7A3B"],
        .shoes : ["FFFFFF", "000000", "8D8983", "AC9F80"],
        .accessories : ["FFFFFF", "000000", "325593", "2E614E", "AD5139", "DF002B"]
    ]
    
    var items: [ClothCategory: [String]] = [
        .hat : ["cap", "suncap"],
        .top : [ "short", "long",  "shirts", "shirtslong", "sleeveless", "pkshirts", "onepiece", "pkonepiece"],
        .bottom : ["shorts", "skirtshort", "skirtsa", "long", "skirtlong"],
        .shoes : ["sandals", "sneakers", "socks", "women"],
        .accessories : []
    ]
    
    var currentItem: Cloth? {
        return selectedItems[currentType]
    }
    
//    var currentItems: [String] {
//        return items[currentType] ?? []
//    }
    
    //MARK: - LifeCycle
    init() {
        changeCategory(with: .hat)
    }
    
    //MARK: - Methods
    func changeCategory(with category: ClothCategory) {
        currentType = category
        currentPresets = presets[category]!
        //옷 아이템도 변경해주기.
        currentItems = items[category]!
    }
    
    func addPreset(hex: String) {
        guard currentPresets.contains(hex) else { return }
        presets[currentType]?.append(hex)
    }
    
    func imageName(name: String) -> String {
        let str = "c-\(currentType)-\(name)"
        return str
    }
    
    func changeColor(hex: String) {
        if selectedItems[currentType] != nil {
            selectedItems[currentType]?.hex = hex
        }
    }
    
    func selectItem(name: String, hex: String) {
        if selectedItems[currentType]?.id == name {
            selectedItems.removeValue(forKey: currentType)
        } else {
            selectedItems[currentType] = Cloth(id: name, hex: hex , category: currentType)
        }
        print(selectedItems)
    }
    
    //CouplleView
    
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
    
    func fetchCurrentHex() -> String? {
        if let hex = selectedItems[currentType]?.hex {
            return hex
        } else {
            return nil
        }
    }
}

