//
//  ChatView.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/09/04.
//

import SwiftUI

struct CommentsView: View {
    @StateObject var keyboard : KeyboardObserver = KeyboardObserver()
    
    public var body: some View {
        VStack {
            AdjustableModalView(keyboard: keyboard) {
                MessageListView()
            }
            CommentInputView()
        }.edgesIgnoringSafeArea(.all)
            .background(Color.white.opacity(0.85))
            .frame(maxWidth:.infinity, maxHeight: UIScreen.main.bounds.height
                   , alignment:.bottom)
            .onAppear{self.keyboard.addObserver()}
            .onDisappear{self.keyboard.removeObserver()}
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            CommentsView()
        }
    }
}
