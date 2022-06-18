//
//  TextFieldView.swift
//  POMPOM
//
//  Created by jiin on 2022/06/13.
//

import SwiftUI
import FirebaseFirestore

//코멘트 쓰는 곳
struct TextFieldView: View {
    private let reference = Firestore.firestore().collection("message")
    
    @State private var comment: String = ""
    
    var body: some View {
        HStack {
            Image("bear")
                .resizable()
                .frame(width: 46 ,height: 47)
                .aspectRatio(contentMode: .fit)
            TextField("코멘트를 입력하세요", text: $comment).frame(height:47).keyboardType(.default)
            Button(action: { Task {
                await sendMessage()
            }
            }){
                Image(systemName: "location.fill")
            }.padding( 18)
                .foregroundColor(comment.isEmpty ? Color(UIColor(red: 192/255, green: 192/255, blue: 196/255, alpha: 1.0)) : Color(UIColor(red: 255/255, green: 81/255, blue: 0/255, alpha: 1.0)))
        }.onAppear(perform : UIApplication.shared.hideKeyboard)
        .background(
            RoundedRectangle(cornerRadius: 24).fill(Color(UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1.0))).frame(height: 47))
    }
    
    func sendMessage() async {
        let myCode =  ConnectionManager().getCode()
        let partnerCode = ConnectionManager().getPartnerCode()
        
        reference.addDocument(data: [
            "id": Int(Date().timeIntervalSince1970*1000),
            "messageContent": comment,
            "messageFrom" :  myCode,
            "messageTo" : partnerCode,
            "timestamp" : Date()
        ]){ err in
            if let error = err {
                print(error.localizedDescription)
                return
            }
        }
        comment = ""
    }
}

