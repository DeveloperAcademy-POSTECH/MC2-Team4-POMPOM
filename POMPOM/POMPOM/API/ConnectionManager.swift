//
//  ConnectionManager.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/06/09.
//

import Foundation
import FirebaseFirestore

struct ConnectionManager {
    let usersRef = Firestore.firestore().collection("users")
    
    // FireBase User document 에서 발급된 코드를 존재 여부를 확인.
    func isExistingCode(code: String) async -> Bool {
        var returnValue: Bool = false
        
        do {
            let querySnapShot = try await usersRef.whereField("code", isEqualTo: code).getDocuments()
            returnValue = querySnapShot.isEmpty ? false : true
        } catch { }
        
        return returnValue
    }
    
    // FireBase Users에 코드를 업로드.
    func saveCode(code: String) {
        usersRef.addDocument(data: [
            "code": code,
            "partner_code": ""
        ]) { err in
            if let err = err {
                dump("Error adding users 아래 문서: \(err)")
                print("DEBUG: ConnectionManager - \(err.localizedDescription)")
            }
        }
    }
    
    // FireBase Users 의 파트너 코드 프로퍼티 업데이트
    func updatePartnerCode(oneId: String, anotherCode: String) {
        usersRef.document(oneId).updateData([
            "partner_code": anotherCode
        ]) { err in
            if let err = err {
                print("DEBUG: ConnectionManager - \(err)")
            }
        }
    }
    
    // 파트너 코드 삭제
    func deletePartnerCode(oneId: String) {
        usersRef.document(oneId).updateData([
            "partner_code" : "" // 빈문자열을 넣어줌.
        ]) { err in
            if let err = err {
                print("DEBUG: ConnectionManager - \(err.localizedDescription)")
            }
        }
    }
    
    // Code 로 Users Document ID 를 가져옴.
    func getIdByCode(code: String) async -> String {
        var returnValue: String = ""
        
        do {
            let querySnapShot = try await usersRef.whereField("code", isEqualTo: code).getDocuments()
            returnValue = querySnapShot.documents[0].documentID // 인덱스 에러 자주 발생
        } catch { }
        
        return returnValue
    }
    
    // 자신의 코드로 자신의 Users 도큐먼트에 파트너코드를 업데이트.
    func updatePartnerCodeBy(ownCode: String) async {
        do {
            try await usersRef.document(getIdByCode(code: ownCode))
            .updateData(["partner_code": " "]) // 공백으로 업데이트.
        } catch {
            print("cannot get document by code")
        }
    }
}
