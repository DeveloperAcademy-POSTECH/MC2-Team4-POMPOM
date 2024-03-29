//
//  SlideModalView.swift
//  POMPOM
//
//  Created by jiin on 2022/06/14.
//

import SwiftUI

struct AdjustableModalView<Content> : View where Content : View {
    @ObservedObject var keyboard: KeyboardObserver
    var content: () -> Content
    
    public init(keyboard: KeyboardObserver ,content: @escaping () -> Content) {
        self.keyboard = keyboard
        self.content = content
    }
    
    public var body: some View {
        ModifiedContent(content: self.content(), modifier: CardView(keyboard: keyboard))
    }
}

struct CardView: ViewModifier {
    @ObservedObject var keyboard: KeyboardObserver
    @State private var isDragging = false
    @State private var curHeight: CGFloat = UIScreen.main.bounds.height * 0.22
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
                .gesture(keyboard.isShowing ? nil : dragGesture)
        }.onChange(of: keyboard.isShowing) { newValue in
            if keyboard.isShowing {
                if curHeight > UIScreen.main.bounds.height - keyboard.height - 300 {
                    curHeight = UIScreen.main.bounds.height - keyboard.height - 300
                }
            }
        }
        .frame(height: curHeight)
        .frame(maxWidth: .infinity)
    }
    
    
    @State private var prevDragTranslation = CGSize.zero
    
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged {val in
                if !isDragging {
                    isDragging = true
                }
                
                let dragAmount = val.translation.height - prevDragTranslation.height
                if curHeight > maxHeight || curHeight < minHeight {
                    curHeight -= dragAmount / 6
                } else {
                    curHeight -= dragAmount
                }
                
                prevDragTranslation = val.translation
            }.onEnded { val in
                prevDragTranslation = .zero
                isDragging = false
                
                if curHeight > maxHeight {
                    curHeight = maxHeight
                }
                else if curHeight < minHeight {
                    curHeight = minHeight
                }
            }
    }
}
