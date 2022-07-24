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
    @Published var currentHex: String = "FFFFFF"
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
            .replaceNil(with: "FFFFFF")
            .sink { hex in
                self.currentHex = hex
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
    
    func setColor(withHex hex: String) {
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
    
    func uploadItem() throws {
        guard let myCode = UserDefaults.standard.string(forKey: "code") else {
            throw CodeError.noLocalCode
        }
        let clotheService = ClothService()
        let clothes = Clothes(items: selectedItems)
        try clotheService.createClothesWith(userCode: myCode, clothes: clothes)
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
        .top : [ "short", "long",  "shirts", "shirtslong", "sleeveless", "pkshirts", "onepiece", "pkonepiece"],
        .bottom : ["shorts", "skirtshort", "skirta", "long", "skirtlong"],
        .shoes : ["sandals", "sneakers", "women"],
        .accessories : ["glasses", "sunglasses"]
    ]
}
