//
//  ChatView.swift
//  POMPOM
//
//  Created by jiin on 2022/06/13.
//

import SwiftUI

//코멘트 쓰는 곳
struct TextFieldView: View {

    @State var comment: String = ""
    
    var body: some View {
        HStack{
            Image("TextFieldDecoration")
                .resizable()
                .frame(width: 46 ,height: 47)
                .aspectRatio(contentMode: .fit)
            TextField("코멘트를 입력하세요", text: $comment).frame(height:47).keyboardType(.default)
            Button(action: sendMessage ){Image(systemName: "location.fill")}.padding( 18).foregroundColor(Color(UIColor(red: 192/255, green: 192/255, blue: 196/255, alpha: 1.0)))
        }
        .background(
            RoundedRectangle(cornerRadius: 24).fill(Color(UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1.0))).frame(height: 47))
    }
    
    func sendMessage() {
        print("이거 만들어야댐")
    }
    
}


struct TextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldView()
    }
}
