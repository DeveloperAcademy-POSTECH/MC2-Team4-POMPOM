//
//  SlideOverCard.swift
//  POMPOM
//
//  Created by jiin on 2022/06/14.
//

import SwiftUI

struct CardContent: View {
    @ObservedObject var keyboard : KeyboardObserver = KeyboardObserver()
    
    public var body: some View {
        VStack{
            SlideOverView {
                MessageListView()
            }.background(Color.white.opacity(0.85))
            TextFieldView()
        }.frame(maxWidth:.infinity,maxHeight: UIScreen.main.bounds.height - (keyboard.isShowing ? keyboard.height + 34: 0), alignment:.bottom) //34: bottom safearea size
            .onAppear{self.keyboard.addObserver()}
            .onDisappear{self.keyboard.removeObserver()}
    }
}

struct SlideOverView<Content> : View where Content : View {
    var content: () -> Content

    
    public init(content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        ModifiedContent(content: self.content(), modifier: CardView())
    }
}


struct CardView: ViewModifier {
    @State private var isDragging = false
    @State private var curHeight: CGFloat = 200
    let minHeight: CGFloat = 200
    let maxHeight: CGFloat = 500
    
    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content
            Rectangle().fill(Color.white).frame(height: 30).mask(LinearGradient(gradient:  Gradient(colors: [.white, .white.opacity(0)]), startPoint: .top, endPoint: .bottom))
            RoundedRectangle(cornerRadius: 2.5)
                .frame(width: 40, height: 5.0)
                .foregroundColor(Color.secondary)
                .padding(10)
                .gesture(dragGesture)
        }
        .frame(height: curHeight)
        .frame(maxWidth: .infinity)
        .animation(isDragging ? nil : .easeInOut(duration: 0.2))
    }

    
    @State private var prevDragTranslation = CGSize.zero
    
    var dragGesture: some Gesture{
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged{val in
                if !isDragging{
                    isDragging = true
                }
                let dragAmount = val.translation.height - prevDragTranslation.height
                if curHeight > maxHeight || curHeight < minHeight {
                    curHeight -= dragAmount / 6
                } else {
                    curHeight -= dragAmount
                }
                
                prevDragTranslation = val.translation
            }.onEnded{val in
                prevDragTranslation = .zero
                isDragging = false
                if curHeight > maxHeight{
                    curHeight = maxHeight
                }
                else if curHeight < minHeight {
                    curHeight = minHeight
                }
            }
    }
}

struct SlideModalView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            CardContent()
        }
    }
}
