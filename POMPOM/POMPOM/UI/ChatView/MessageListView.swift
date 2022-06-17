//
//  MessageListView.swift
//  POMPOM
//
//  Created by jiin on 2022/06/13.
//

import SwiftUI

//코멘트 리스트
struct MessageListView: View {
    @StateObject var data = messageData()
    @State private var myCode: String?
    
    var body: some View {
        ScrollViewReader { val in
            ScrollView {
                VStack(spacing: 15) {
                    //버블간 간격 15
                    
                    //DateDisplayView()
                    
                    ForEach(data.messages) { message in
                        MessageBubbleView(chatMessage: message.messageContent,
                                          isUserBubble: message.messageFrom == myCode ? true : false,
                                          recievedBubble: message.messageTo == myCode ? true : false,
                                          commentedTime: message.timestamp)
                            .task {
                                self.myCode = CodeManager().getCode()
                            }
                        
                    }
                    .onChange(of: data.messages) { newValue in
                        val.scrollTo(data.messages.last!.id, anchor: .bottom)
                    }
                    .onAppear{
                        val.scrollTo(data.messages.last!.id, anchor: .bottom)
                    }
                }.padding(16)
                 .rotationEffect(Angle(degrees: 180))
            }
            .rotationEffect(Angle(degrees: 180))
        }
    }
}
