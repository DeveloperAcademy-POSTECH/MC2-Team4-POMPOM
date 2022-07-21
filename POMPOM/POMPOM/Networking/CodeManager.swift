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
    
    // UserDefault 에서 코드를 가져옴. 없으면 코드를 생성해서 서버에 저장함..
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
    
    //새로운 코드를 발급
    func setNewCode() async -> String {
        var newCode: String = ""
        
        repeat {
            newCode = generateCode(length: 10)
        } while await connectionManager.isExistingCode(code: newCode) // 서버에 중복된 코드가 존재하지 않도록 함.
        
        return newCode
    }
    
    // Local에서 임의의 코드를 생성.
    private func generateCode(length: Int) -> String {
        let elements = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return String((0 ..< length).map { _ in elements.randomElement()! })
    }
    
    //파트너 코드를 넣으면 파트너와 연결해주는 로직
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
        throw ConnectionManagerResultType.success // ⚠️ 고쳐야 된다!
    }
    
    // UserDefaults 에서 파트너 코드를 가져옴.
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
    
    // FireBase 에서 파트너 코드를 가져옴.
    func getPartnerCodeFromServer(completion: @escaping (String) -> Void) async {
        
        
        connectionManager.usersRef.document(await connectionManager.getIdByCode(code: getCode()))
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
    
    // 파트너 코드를 삭제함. 연동해지
    func deletePartnerCode(completion: @escaping (String) -> Void) {
        Task {
            await connectionManager.updatePartnerCodeBy(ownCode: getPartnerCode())
            await connectionManager.updatePartnerCodeBy(ownCode: getCode())
        }
        
        if let _ = UserDefaults.standard.string(forKey: "partner_code") {
            UserDefaults.standard.removeObject(forKey: "partner_code")
            
        }
        completion("연동이 해지되었습니다.")
    }
}


//에러 타입.
enum ConnectionManagerResultType: Error {
    case success // ⚠️ 고치자!
    case callMySelf // 자신의 코드를 불러오는 경우
    case invalidPartnerCode // 일치하는 파트너 코드가 없는 경우
}


