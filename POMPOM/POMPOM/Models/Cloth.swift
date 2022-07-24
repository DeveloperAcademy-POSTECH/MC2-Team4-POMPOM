//
//  Cloth.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/06/14.
//

import Foundation

struct Cloth: Identifiable, Codable {
    var id: String
    var hex: String
    var category: ClothCategory
}

struct Clothes: Codable {
    var items: [ClothCategory : Cloth]
}

enum ClothCategory: String, CaseIterable, Identifiable, Codable {
    case hat
    case top
    case bottom
    case shoes
    case accessories
    
    var id: ClothCategory {
        self
    }

    var koreanSubtitle: String {
        switch self {
        case .hat:
            return "모자"
        case .top:
            return "상의"
        case .bottom:
            return "하의"
        case .shoes:
            return "신발"
        case .accessories:
            return "악세사리"
        }
    }
}
