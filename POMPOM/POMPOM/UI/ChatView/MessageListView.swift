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
    @State private var scrolled = false
    @State private var myCode: String?
    
    
    
    var body: some View {
        ScrollViewReader { value in
            ScrollView {
                VStack(spacing: 15) {
                    //버블간 간격 15
                    
                    //DateDisplayView()
                    
                    ForEach(data.messages) { message in
                        MessageBubbleView(chatMessage: message.messageContent, isUserBubble: message.messageFrom == myCode ? true : false, commentedTime: message.timestamp) //temp
                            .task {
                                self.myCode = await CodeManager().getCode()
                            }
                            .onAppear {
                                if message.id == self.data.messages.last!.id && scrolled {
                                    value.scrollTo(data.messages.last!.id, anchor: .bottom)
                                    scrolled = true
                                }
                            }
                    }.onChange(of: data.messages) { newValue in
                        value.scrollTo(data.messages.last!.id, anchor: .bottom)
                    }
                }.padding(16)
                 .rotationEffect(Angle(degrees: 180))
            }
            .rotationEffect(Angle(degrees: 180))
        }
    }
}

struct MessageListView_Previews: PreviewProvider {
    static var previews: some View {
        MessageListView()
    }
}
