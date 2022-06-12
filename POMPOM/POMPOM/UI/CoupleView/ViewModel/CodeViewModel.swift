//
//  CodeViewModel.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/06/09.
//

import Foundation

struct CodeViewModel {
    private static let code: String = initializeCode()
    
    static func getCode() -> String { code }
    
    static func initializeCode() -> String {
        // UserDefaults에 이미 code가 있을 때
        if let defaultCode: String = UserDefaults.standard.string(forKey: "code") {
            return defaultCode;
        }
        // UserDefaults에 code가 없을 때
        else {
            let code: String = generateCode(length: 10)
            // code가 중복되지 않고 saveCode()가 100% 성공적으로 완료된다는 가정
            ConnectionManager.saveCode(code: code)
            return code;
        }
    }
    
    // 길이가 length고, 숫자와 영문 대문자로만 이뤄진 코드 생성 및 반환
    static func generateCode(length: Int) -> String {
        let elements = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return String((0 ..< length).map { _ in elements.randomElement()! })
    }
}
