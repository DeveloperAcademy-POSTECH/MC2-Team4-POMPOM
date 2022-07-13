//
//  PickerViewModel.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/06/13.
//

import Combine
import SwiftUI
import SystemConfiguration

final class PickerCombineViewModel: ObservableObject {
    @Published var selectedItems: [ClothCategory : Cloth] = [:]
    @Published var currentCategory: ClothCategory = .hat
    @Published var currentHex: String = "FFFFFF"
    @Published var categoryGridOffset: CGFloat = Constant.screenWidth / 2 - 60
    
    @Published var presets: [String] = []
    @Published var items: [Cloth.ID] = []
    
    private let setCategorySubject = CurrentValueSubject<ClothCategory, Never>(.hat)
    private let setColorSubject = CurrentValueSubject<String?, Never>("FFFFFF")
    private let selectItemSubject = PassthroughSubject<Cloth?, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(clothes: [Cloth]) {
        
        let setCategory = setCategorySubject.share()
        
        setCategory
            .removeDuplicates()
            .assign(to: \.currentCategory, on: self)
            .store(in: &cancellables)
        
        setCategory
            .removeDuplicates()
            .compactMap { currentCategory in
                self.presetDic[currentCategory]
            }
            .assign(to: \.presets, on: self)
            .store(in: &cancellables)
        
        setCategory
            .removeDuplicates()
            .compactMap { currentCategory in
                self.itemDic[currentCategory]
            }
            .assign(to: \.items, on: self)
            .store(in: &cancellables)
        
        
        setColorSubject
            .replaceNil(with: "FFFFFF") //값이 nil 일 경우 흰색으로 대체
            .removeDuplicates()
            .assign(to: \.currentHex, on: self)
            .store(in: &cancellables)
        
        selectItemSubject
            .compactMap{ $0 } //nil 값 제거
            .sink { cloth in
                self.selectedItems[self.currentCategory] = cloth
            }
            .store(in: &cancellables)
        
        
    }
    
    func setCategory(_ category: ClothCategory) {
        setCategorySubject.send(category)
    }
    
    func setColor(withHex hex: String?) {
        setColorSubject.send(hex)
    }
    
    func selectItem(cloth: Cloth?) {
        selectItemSubject.send(cloth)
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
        .top : [ "short", "long",  "shirts", "shirtslong", "sleeveless", "pkshirts", "onepiece", "pkonepiece"],
        .bottom : ["shorts", "skirtshort", "skirta", "long", "skirtlong"],
        .shoes : ["sandals", "sneakers", "women"],
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
        .top : [ "short", "long",  "shirts", "shirtslong", "sleeveless", "pkshirts", "onepiece", "pkonepiece"],
        .bottom : ["shorts", "skirtshort", "skirta", "long", "skirtlong"],
        .shoes : ["sandals", "sneakers", "women"],
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
    
    func uploadItem() {
        if let defaultCode: String = UserDefaults.standard.string(forKey: "code") {
            networkManager.saveClothes(userCode: defaultCode, clothes: selectedItems)
        } else {
            print("DEBUG: 사용자 코드 조회 실패")
        }
    }
}

