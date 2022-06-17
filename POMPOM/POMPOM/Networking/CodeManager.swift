//
//  CodeViewModel.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/06/09.
//

import Foundation

struct CodeManager {
    private let code: String = ""
    private let connectionManager: ConnectionManager = ConnectionManager()
    
    @discardableResult
    func getCode() -> String {
        // UserDefaults에 이미 code가 있을 때
        if let defaultCode: String = UserDefaults.standard.string(forKey: "code") {
            return defaultCode
        }
        // UserDefaults에 code가 없을 때
        else {
//            let newCode = await setNewCode()
            let newCode = generateCode(length: 10)
            DispatchQueue.global().async {
                connectionManager.saveCode(code: newCode)
            }
            UserDefaults.standard.set(newCode, forKey: "code")
            print("DEUBG: 코드 생성 완료 - \(newCode)")
            return newCode
        }
    }
    
    func setNewCode() async -> String {
        var newCode: String = ""
        
        repeat {
            newCode = generateCode(length: 10)
        } while await connectionManager.isExistingCode(code: newCode)
        
        return newCode
    }
    
    // 길이가 length고, 숫자와 영문 대문자로만 이뤄진 코드 생성 및 반환
    private func generateCode(length: Int) -> String {
        let elements = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return String((0 ..< length).map { _ in elements.randomElement()! })
    }
    
    func connectWithPartner(partnerCode: String) async throws {
        // partnerCode를 본인의 코드로 입력했는지 확인
        guard partnerCode != getCode() else {
            throw ConnectionManagerResultType.callMySelf
        }
        
        // partnerCode가 존재하는지부터 확인
        guard await connectionManager.isExistingCode(code: partnerCode) else {
            throw ConnectionManagerResultType.invalidPartnerCode
        }
        
        let ownCode: String = getCode()
        
        let ownId: String = await connectionManager.getIdByCode(code: ownCode)
        let partnerId: String = await connectionManager.getIdByCode(code: partnerCode)
        
        connectionManager.updatePartnerCode(oneId: ownId, anotherCode: partnerCode)
        connectionManager.updatePartnerCode(oneId: partnerId, anotherCode: ownCode)
        UserDefaults.standard.set(partnerCode, forKey: "partner_code")
        throw ConnectionManagerResultType.success
    }
    
    func getPartnerCode() -> String {
        // UserDefaults에 partner_code가 있을 때
        if let partnerCode: String = UserDefaults.standard.string(forKey: "partner_code") {
            return partnerCode
        }
        // UserDefaults에 partner_code가 없을 때
        else {
            return ""
        }
    }
    
    func getPartnerCodeFromServer(completion: @escaping (String) -> Void) async {
        
        
        connectionManager.usersRef.document(await connectionManager.getIdByCode(code: getCode()))
            .addSnapshotListener { snapShot, err in
                if let err = err {
                    dump("\(err)")
                } else {
                    guard let data = snapShot?.data()?["partner_code"] as? String else { return }
                    UserDefaults.standard.set(data, forKey: "partner_code")
                    completion(data)
                }
            }
    }
}

enum ConnectionManagerResultType: Error {
    case success
    case callMySelf // 자신의 코드를 불러오는 경우
    case invalidPartnerCode // 일치하는 파트너 코드가 없는 경우
}


