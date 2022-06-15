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
                MessageBubbleView(chatMessage: "a\ns\nd\nf\n \n", isUserBubble: true)
                MessageBubbleView(chatMessage: "허러럼ㄴ어럼ㄴㅇ", isUserBubble: false)
                MessageBubbleView(chatMessage: "1234567890!@#$%^&*()", isUserBubble: false)
                MessageBubbleView(chatMessage: "이거어디까지\n길\n어\n\n\n\n\n지는\n거\n에\n요\nㅋ\nㅋ\nㅋ\nㅋ\nㅋ", isUserBubble: false)
                MessageBubbleView(chatMessage: "하이디라오가고싶다", isUserBubble: false)
                MessageBubbleView(chatMessage: "고구마와플이정말맛있습니다", isUserBubble: true)
                MessageBubbleView(chatMessage: "아아아아아아아앙악 아이들 콘서트 빨리 가고싶다 울아가등 ㄹㄴ읾ㄴㅇ롬ㄴ애랴ㅗㅂ재댜갭쟏고ㅓ샣뱌ㅗㄱ히마넝레ㅑ머ㅗ네래", isUserBubble: false)
                MessageBubbleView(chatMessage: "에이쌥 내 통장잔고 반 쪼 가리", isUserBubble: false)
            }.padding(16)
        }
    }
}

struct MessageListView_Previews: PreviewProvider {
    static var previews: some View {
        MessageListView()
    }
}

/*
 
 message
 message_id
 message_from
 message_to
 message_content
 message_time
 
 */
