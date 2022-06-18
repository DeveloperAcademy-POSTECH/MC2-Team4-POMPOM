//
//  CodeViewModel.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/06/09.
//

import Foundation

struct ConnectionManager {
    private let code: String = ""
    private let codeManager: CodeManager = CodeManager()
    
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
                codeManager.saveCode(code: newCode)
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
        } while await codeManager.isExistingCode(code: newCode)
        
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
        guard await codeManager.isExistingCode(code: partnerCode) else {
            throw ConnectionManagerResultType.invalidPartnerCode
        }
        
        let ownCode: String = getCode()
        
        let ownId: String = await codeManager.getIdByCode(code: ownCode)
        let partnerId: String = await codeManager.getIdByCode(code: partnerCode)
        
        codeManager.updatePartnerCode(oneId: ownId, anotherCode: partnerCode)
        codeManager.updatePartnerCode(oneId: partnerId, anotherCode: ownCode)
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
        
        
        codeManager.usersRef.document(await codeManager.getIdByCode(code: getCode()))
            .addSnapshotListener { snapShot, err in
                if let err = err {
                    dump("\(err)")
                } else {
                    guard let data = snapShot?.data()?["partner_code"] as? String else { return }
                    var temp = ""
                    print(data)
                    if data != " " {
                        temp = data
                    }
                    UserDefaults.standard.set(temp, forKey: "partner_code")
                    print(temp + "wow")
                    completion(temp)
                }
            }
    }
    
    func deletePartnerCode(completion: @escaping (String) -> Void) {
        Task {
            await codeManager.updatePartnerCodeBy(ownCode: getPartnerCode())
            await codeManager.updatePartnerCodeBy(ownCode: getCode())
        }
        
        if let _ = UserDefaults.standard.string(forKey: "partner_code") {
            UserDefaults.standard.removeObject(forKey: "partner_code")
            
        }
        completion("연동이 해지되었습니다.")
    }
}

enum ConnectionManagerResultType: Error {
    case success
    case callMySelf // 자신의 코드를 불러오는 경우
    case invalidPartnerCode // 일치하는 파트너 코드가 없는 경우
}


