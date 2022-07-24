//
//  Clothes.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/07/24.
//

import Foundation

struct Clothes: Codable {
    var hat: Item
    var top: Item
    var bottom: Item
    var shoes: Item
    var accessories: Item
    
    struct Item: Codable {
        let name: String
        let hex: String
    }
}
