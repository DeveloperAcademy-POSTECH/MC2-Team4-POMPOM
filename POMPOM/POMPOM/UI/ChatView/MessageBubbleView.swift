//
//  MessageBubbleView.swift
//  POMPOM
//
//  Created by jiin on 2022/06/13.
//

import SwiftUI

//버블 딱 하나(시간 + 내용)
struct MessageBubbleView: View {
    var chatMessage: String
    var isUserBubble: Bool
    var commentedTime: Date
    
    var body: some View {
        HStack(alignment: .bottom) {
            if isUserBubble { //쓴 사람 버블이라 시간이 채팅 내용 왼쪽에 와야함
                chatTime
                chatBubble
            } else {
                chatBubble
                chatTime
            }

        }.frame(maxWidth: .infinity, alignment: (isUserBubble ? .trailing : .leading))
    }
    
    var chatBubble:  some View {
        return Text(chatMessage)
            .padding([.bottom, .top], 14)
            .padding([.trailing, .leading], 18)
            .foregroundColor(isUserBubble ? Color.white : Color.black)
            .background(isUserBubble ? Color.black : Color(UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1.0)))
            .cornerRadius(24)
    }
    
    var chatTime: some View {
        return Text(currentTime(time: commentedTime))
            .foregroundColor(Color(UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1.0)))
    }
    
    func currentTime(time: Date) -> String { //시간 string return
        let date = time
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let min = calendar.component(.minute, from: date)
        let timeString = "\(hour):\(min)"
        
        return timeString
    }
}
