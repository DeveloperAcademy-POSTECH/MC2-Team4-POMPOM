//
//  MessageBubbleView.swift
//  POMPOM
//
//  Created by jiin on 2022/06/13.
//

import SwiftUI

struct MessageBubbleView: View {
    var chatMessage: String
    var isUserBubble: Bool
    
    var body: some View {
        Text(chatMessage)
            .padding([.bottom, .top], 14)
            .padding([.trailing, .leading], 18)
            .foregroundColor(isUserBubble ? Color.white : Color.black)
            .background(isUserBubble ? Color.black : Color(UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1.0)))
            .cornerRadius(24)
    }
}

struct MessageBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        MessageBubbleView(chatMessage: "HI", isUserBubble: false)
    }
}
