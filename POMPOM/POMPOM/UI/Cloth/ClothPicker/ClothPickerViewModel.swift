//
//  PickerViewModel.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/06/13.
//

import Combine
import SwiftUI
import SystemConfiguration

final class PickerCombineViewModel: ClothesViewModel {
    @Published var currentCategory: ClothCategory = .hat
    @Published var currentHex: String = "FFFFFF" {
        didSet {
            selectedItems[currentCategory]?.hex = currentHex
        }
    }
    @Published var categoryGridOffset: CGFloat = Constant.screenWidth / 2 - 60
    @Published var isColorEnable: Bool = true
    
    @Published var currentPresets: [String] = []
    @Published var currentItems: [Cloth.ID] = []
    
    var currentItem: Cloth? {
        selectedItems[currentCategory]
    }
    
    private let setCategorySubject = CurrentValueSubject<ClothCategory, Never>(.hat)
    private let setColorSubject = CurrentValueSubject<String?, Never>("FFFFFF")
    private let selectItemSubject = PassthroughSubject<Cloth?, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        let setCategory = setCategorySubject.share()
        
        setCategory
            .removeDuplicates()
            .assign(to: \.currentCategory, on: self)
            .store(in: &cancellables)
        
        setCategory
            .removeDuplicates()
            .compactMap { category in
                self.presetDic[category]
            }
            .assign(to: \.currentPresets, on: self)
            .store(in: &cancellables)
        
        setCategory
            .removeDuplicates()
            .compactMap { category in
                self.itemDic[category]
            }
            .assign(to: \.currentItems, on: self)
            .store(in: &cancellables)
        
        setCategory
            .removeDuplicates()
            .map { category in
                category != .accessories
            }
            .assign(to: \.isColorEnable, on: self)
            .store(in: &cancellables)
        
        setCategory
            .removeDuplicates()
            .map { category in
                self.selectedItems[category]?.hex
            }
            .sink { hex in
                self.setColorSubject.send(hex)
            }
            .store(in: &cancellables)
        
        
        let setColor = setColorSubject.share()
        
        setColor
            .replaceNil(with: "FFFFFF") //값이 nil 일 경우 흰색으로 대체
            .removeDuplicates()
            .assign(to: \.currentHex, on: self)
            .store(in: &cancellables)
        
        setColor
            .replaceNil(with: "FFFFFF")
            .removeDuplicates()
            .sink { hex in
                self.selectedItems[self.currentCategory]?.hex = hex
             }
            .store(in: &cancellables)
            
        selectItemSubject
            .sink { cloth in
                self.selectedItems[self.currentCategory] = cloth
            }
            .store(in: &cancellables)
        
        setCategorySubject.send(.hat)
        selectItemSubject.send(selectedItems[currentCategory])
    }
    
    func setCategory(_ category: ClothCategory) {
        setCategorySubject.send(category)
    }
    
    func setColor(withHex hex: String?) {
        setColorSubject.send(hex)
    }
    
    func selectItem(name: String?) {
        guard let name = name else { return }
        let cloth = Cloth(id: name, hex: currentHex, category: currentCategory)
        if selectedItems[currentCategory]?.id == name {
            selectItemSubject.send(nil)
        } else {
            selectItemSubject.send(cloth)
        }
        
    }
    
    func uploadItem() {
        if let defaultCode: String = UserDefaults.standard.string(forKey: "code") {
            networkManager.saveClothes(userCode: defaultCode, clothes: selectedItems)
        } else {
            print("DEBUG: 사용자 코드 조회 실패")
        }
    }
    
    func fetchImageString(withName name: String) -> String {
        return "c-\(currentCategory)-\(name)"
    }
    
    // 기본 컬러 프리셋
    var presetDic: [ClothCategory : [String]] = [
        .hat : ["FFFFFF", "000000", "325593", "2E614E", "AD5139", "DF002B", "6F6F71", "D0DBE2", "DAC7C5"],
        .top : ["FFFFFF", "000000", "BAD2F5", "C5C5C7", "23293F", "00914E", "FF5100", "3F2D24", "32323B", "FAF6EA", "E3EDE8", "F7EDF8"],
        .bottom : ["FFFFFF", "C5C5C7", "ACC8E0","7489A3", "1D2433", "FAF3E6", "CBAF86", "6D7A3B"],
        .shoes : ["FFFFFF", "000000", "8D8983", "AC9F80"],
        .accessories : ["FFFFFF", "000000", "325593", "2E614E", "AD5139", "DF002B"]
    ]
    
    var itemDic: [ClothCategory: [String]] = [
        .hat : ["cap", "suncap"],
        .top : [ "short", "long", "crop", "shirts", "shirtslong", "sleeveless", "pkshirts", "onepiece", "pkonepiece", "sleevelessonepiece","linesleeveless", "offshoulder"],
        .bottom : ["shorts", "skinny", "tennisskirt", "skirtshort", "skirta", "long", "skirtlong"],
        .shoes : ["sandals", "flat","slipper", "sneakers", "boots", "women"],
        .accessories : ["glasses", "sunglasses"]
    ]
}

class PickerViewModel: ClothesViewModel {
    //MARK: - Propeties
    @Published var currentType: ClothCategory = .hat
    //UI 에 보여지는 컬러, 옷
    @Published var currentPresets: [String] = []
    @Published var currentItems: [String] = []
    //선택된 옷 + 컬러

    override init() {
        super.init()
        changeCategory(with: .hat)
    }

    
    // 기본 컬러 프리셋
    var presets: [ClothCategory : [String]] = [
        .hat : ["FFFFFF", "000000", "325593", "2E614E", "AD5139", "DF002B", "6F6F71", "D0DBE2", "DAC7C5"],
        .top : ["FFFFFF", "000000", "BAD2F5", "C5C5C7", "23293F", "00914E", "FF5100", "3F2D24", "32323B", "FAF6EA", "E3EDE8", "F7EDF8"],
        .bottom : ["FFFFFF", "C5C5C7", "ACC8E0","7489A3", "1D2433", "FAF3E6", "CBAF86", "6D7A3B"],
        .shoes : ["FFFFFF", "000000", "8D8983", "AC9F80"],
        .accessories : ["FFFFFF", "000000", "325593", "2E614E", "AD5139", "DF002B"]
    ]
    
    var items: [ClothCategory: [String]] = [
        .hat : ["cap", "suncap"],
        .top : [ "short", "long", "crop", "shirts", "shirtslong", "sleeveless", "pkshirts", "onepiece", "pkonepiece", "lineonepiece","linesleeveless", "offshoulder"],
        .bottom : ["shorts", "skinny", "tennisskirt", "skirtshort", "skirta", "long", "skirtlong"],
        .shoes : ["sandals", "flat","slipper", "sneakers", "boots", "women"],
        .accessories : ["glasses", "sunglasses"]
    ]
    
    var selectedItem: Cloth? {
        return selectedItems[currentType]
    }
    
    var selectedItemColor: String? {
        if let hex = selectedItems[currentType]?.hex {
            return hex
        } else {
            return nil
        }
    }
    
    var isCategoryColorEnable: Bool {
        switch currentType {
        case .accessories:
            return false
        default:
            return true
        }
    }

    
    //MARK: - Methods
    func changeCategory(with category: ClothCategory) {
        currentType = category
        currentPresets = presets[category] ?? []
        currentItems = items[category] ?? []
    }
    
    func addPreset(hex: String) {
        guard currentPresets.contains(hex) else { return }
        presets[currentType]?.append(hex)
    }
    
    func changeSelectedColor(with hex: String) {
        if selectedItems[currentType] != nil {
            selectedItems[currentType]?.hex = hex
        }
    }
    
    func uploadItem() {
        if let defaultCode: String = UserDefaults.standard.string(forKey: "code") {
            networkManager.saveClothes(userCode: defaultCode, clothes: selectedItems)
        } else {
            print("DEBUG: 사용자 코드 조회 실패")
        }
    }
    
    func fetchAssetName(name: String) -> String {
        let str = "c-\(currentType)-\(name)"
        return str
    }
    
    func selectItem(name: String, hex: String) {
        if selectedItems[currentType] != nil {
            if selectedItems[currentType]?.id == name {
                selectedItems[currentType] = Cloth(id: " ", hex: hex, category: currentType)
            } else {
                //해당 key 에 해당하는 객체가 이미 존재하는 경우에는 새 객체를 생성하는 것이 아닌 값만 변경해준다.
                selectedItems[currentType]?.hex = hex
                selectedItems[currentType]?.id = name
            }
        } else {
            withAnimation(.easeOut) {
                selectedItems[currentType] = Cloth(id: name, hex: hex , category: currentType)
            }
        }
    }
}

