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
    
    var body: some View {
        HStack (alignment: .bottom){
            if isUserBubble{ //쓴 사람 버블이라 시간이 채팅 내용 왼쪽에 와야함
                chatTime()
                chatBubble()
            } else {
                chatBubble()
                chatTime()
            }

        }.frame(maxWidth: .infinity, alignment: (isUserBubble ? .trailing : .leading))
    }
    
    func chatBubble() -> some View {
        return Text(chatMessage)
            .padding([.bottom, .top], 14)
            .padding([.trailing, .leading], 18)
            .foregroundColor(isUserBubble ? Color.white : Color.black)
            .background(isUserBubble ? Color.black : Color(UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1.0)))
            .cornerRadius(24)
    }
    
    func chatTime() -> some View {
        return Text(getCurrentTime())
            .foregroundColor(Color(UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1.0)))
    }
    
    func getCurrentTime() -> String { //현재 시간 string return
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let min = calendar.component(.minute, from: date)
        let timeString = "\(hour):\(min)"
        
        return timeString
    }
}

struct MessageBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        MessageBubbleView(chatMessage: "안녕하세요육칠팔구십그다음은더많겠다아아아아아아아아호에에에에에에", isUserBubble: true)
    }
}
