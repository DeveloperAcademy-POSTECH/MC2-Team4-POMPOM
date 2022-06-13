//
//  MessageListView.swift
//  POMPOM
//
//  Created by jiin on 2022/06/13.
//

import SwiftUI

//코멘트 리스트
struct MessageListView: View {
    var body: some View {
        ScrollView{
            VStack(spacing: 15) {
                //버블간 간격 15
                //채팅 갯수따라 나와야함 아직 안만듬
                MessageBubbleView(chatMessage: "There are a lot of premium iOS templates on iosapptemplates.com",
                                  isUserBubble: false)
                MessageBubbleView(chatMessage: "asdf", isUserBubble: true)
                MessageBubbleView(chatMessage: "asdaaaaaaaaaaadfasdfasdfasdfewsdfasdff", isUserBubble: false)
                MessageBubbleView(chatMessage: "asdaaaaaaaaaaadfasdfasdfasdfewsdfasdff", isUserBubble: false)
                MessageBubbleView(chatMessage: "asdaaaaaaaaaaadfasdfasdfasdfewsdfasdff", isUserBubble: false)
                MessageBubbleView(chatMessage: "asdaaaaaaaaaaadfasdfasdfasdfewsdfasdff", isUserBubble: false)
                
                
                
            }.padding(16)
        }
    }
}

struct MessageListView_Previews: PreviewProvider {
    static var previews: some View {
        MessageListView()
    }
}
