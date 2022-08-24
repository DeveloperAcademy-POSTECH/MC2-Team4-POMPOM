//
//  CodeManagerTest.swift
//  POMPOM
//
//  Created by 김남건 on 2022/07/24.
//

import Foundation
import SwiftUI

struct CodeManagerTest {
    @AppStorage("code") var code: String?
    @AppStorage("partner_code") var partnerCode: String?
    
    func generateRandomCode() -> String {
        let elements = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return String((0..<10).map { _ in elements.randomElement()! })
    }
    
    func assignNewCode() async throws -> String {
        var newCode = ""
        
        repeat {
            newCode = generateRandomCode()
        } while try await CodeService.shared.isExistingCode(code: newCode)
        
        UserDefaults.standard.set(newCode, forKey: "code")
        return newCode
    }
    
    mutating func connectWithPartner(partnerCode: String) async throws {
        guard let code = code else {
            throw CodeServiceError.myCodeNotExists
        }
        
        guard partnerCode != code else {
            throw CodeServiceError.connectToMySelf
        }
        
        guard try await CodeService.shared.isExistingCode(code: partnerCode) else {
            throw CodeServiceError.invalidPartnerCode
        }
        
        async let isMyDocumentUpdated = try CodeService.shared.updatePartnerCode(myCode: code, partnerCode: partnerCode)
        
        async let isPartnerDocumentUpdated = try CodeService.shared.updatePartnerCode(myCode: partnerCode, partnerCode: code)
        
        let _ = (try await isMyDocumentUpdated, try await isPartnerDocumentUpdated)
        
        self.partnerCode = partnerCode
    }
    
    func deletePartnerCode() async throws {
        guard let code = code else {
            return
        }
        
        guard let partnerCode = partnerCode else {
            return
        }
        
        async let isMyDocumentUpdated = try CodeService.shared.deletePartnerCode(in: code)
        async let isPartnerDocumentUpdated = try CodeService.shared.deletePartnerCode(in: partnerCode)
        
        let _ = (try await isMyDocumentUpdated, try await isPartnerDocumentUpdated)
        self.partnerCode = nil
    }
}

enum CodeServiceError: Error {
    case myCodeNotExists, connectToMySelf, invalidPartnerCode
}
