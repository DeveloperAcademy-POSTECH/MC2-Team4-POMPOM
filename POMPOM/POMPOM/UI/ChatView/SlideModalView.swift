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
            Rectangle().fill(Color.white).frame(height: 30).mask(LinearGradient(gradient:  Gradient(colors: [.white, .white.opacity(0)]), startPoint: .top, endPoint: .bottom)) //gradient 사라지게 어케주냐 아오옹먼ㅇㄹㅁㄴㅇㄹ
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

//@available(iOS 15.0, *)
struct SlideModalView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            CardContent()
        }
    }
}

/*
 모달에 메시지 목록이 뜸
 코멘트 뷰는 따로
 클릭하면 키보드 따로 올라오는데, 모달에는 안먹음 그래서 밑에 내용이 안보임
 -> 이걸 먹이려면 코멘트뷰를 모달에 넣어야 하는데 그러면 밑으로 내려감
 -> 위치 fix하면 키보드 올라올 때 같이 안올라감
 1. 모달 끝부분을 같이 올릴 수 있는가? ->해결
 2. 그라디언트 색말고 사라지게.어케줌.. ->그냥 이대로 살자
 3. 코멘트 칸 밑에 전부 흰색으로 채워도 될런지? ->이것도 1해결 하면서 해결함
 
 새로운 문제!
 1. 모달 창이 길어지면 코멘트가 밑으로 사라짐 -> keyboard observing추가해서 해결
 2. 곰돌이가 사라짐 이제ㅋㅋ
 */
