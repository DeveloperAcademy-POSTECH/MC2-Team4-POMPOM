//
//  CodeViewModel.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/06/09.
//

import Foundation

struct CodeViewModel {
    private static let code: String = ""
    
    static func getCode() async -> String {
        // UserDefaults에 이미 code가 있을 때
        if let defaultCode: String = UserDefaults.standard.string(forKey: "code") {
            return defaultCode;
        }
        // UserDefaults에 code가 없을 때
        else {
            let newCode = await setNewCode()
            ConnectionManager.saveCode(code: newCode)
            UserDefaults.standard.set(newCode, forKey: "code")
            return newCode;
        }
    }
    
    static func setNewCode() async -> String {
        var newCode: String = ""
        
        repeat {
            newCode = generateCode(length: 10)
        } while await ConnectionManager.isUniqueCode(code: newCode) == false
        
        return newCode
    }
    
    // 길이가 length고, 숫자와 영문 대문자로만 이뤄진 코드 생성 및 반환
    static func generateCode(length: Int) -> String {
        let elements = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return String((0 ..< length).map { _ in elements.randomElement()! })
    }
    
    
}
