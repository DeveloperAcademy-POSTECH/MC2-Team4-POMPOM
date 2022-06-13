//
//  ChatView.swift
//  POMPOM
//
//  Created by jiin on 2022/06/13.
//

import SwiftUI



//struct OvalTextFieldStyle: TextFieldStyle {
//    func _body(configuration: TextField<Self._Label>) -> some View {
//        configuration
//            .background()
//    }
//}

//하프모달
struct ChatView: View {
    @State
    var comment: String = ""
    
    var body: some View {
        VStack{
            MessageListView()
            HStack{
                Image("TextFieldDecoration")
                    .resizable()
                    .frame(width: 30, height: 30)
                TextField("코멘트를 입력하세요", text: $comment).frame(height:47).background(
                    RoundedRectangle(cornerRadius: 24).fill(Color(UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1.0))))
            }
            
            
        }
    }
    
    
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
