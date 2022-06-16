//
//  PresetColor+Extensions.swift
//  POMPOM
//
//  Created by 김남건 on 2022/06/16.
//

import Foundation
import CoreData

extension PresetColor: BaseModel {
    static func byClothType(_ clothType: ClothCategory) -> [PresetColor] {
        let request = PresetColor.fetchRequest()
        request.predicate = NSPredicate(format: "%K = %@", #keyPath(PresetColor.clothCategoryString), clothType.rawValue)
        
        do {
            return try CoreDataManager.shared.viewContext.fetch(request)
        } catch {
            return []
        }
    }
    
    private static func by(clothType: ClothCategory, hex: String) -> PresetColor? { // 같은 카테고리에 같은 색이 있는지 확인용
        let request = PresetColor.fetchRequest()
        
        let hexPredicate = NSPredicate(format: "%K = %@", #keyPath(PresetColor.hex), hex)
        let clothTypePredicate = NSPredicate(format: "%K = %@", #keyPath(PresetColor.clothCategoryString), clothType.rawValue)
        
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [hexPredicate, clothTypePredicate])
        
        do {
            return try CoreDataManager.shared.viewContext.fetch(request).first
        } catch {
            return nil
        }
    }
    
    static func savePresetColor(clothType: ClothCategory, hex: String) {
        if by(clothType: clothType, hex: hex) != nil { return } // 중복 저장 방지
        
        let newPresetColor = PresetColor(context: CoreDataManager.shared.viewContext)
        newPresetColor.hex = hex
        newPresetColor.clothCategoryString = clothType.rawValue
        
        newPresetColor.save()
    }
}
