////
////  SlideOverCard.swift
////  POMPOM
////
////  Created by jiin on 2022/06/14.
////
//
//import SwiftUI
//
//
//struct CardContent: View {
//    public var body: some View {
//        ZStack {
//            //Color.gray.ignoresSafeArea()
//            Text("Main View")
//            VStack{
//                SlideOverView {
//                    MessageListView()
//                }
//                TextFieldView()
//            }
//        }
//    }
//}
//
//struct SlideOverView<Content> : View where Content : View {
//    var content: () -> Content
//
//    public init(content: @escaping () -> Content) {
//        self.content = content
//    }
//
//    public var body: some View {
//        ModifiedContent(content: self.content(), modifier: CardView())
//    }
//}
//
//
//struct CardView: ViewModifier {
//    @State private var dragging = false
//    @GestureState private var dragTracker: CGSize = CGSize.zero
//    @State private var position: CGFloat = UIScreen.main.bounds.height / 2
//
//    func body(content: Content) -> some View {
//        ZStack(alignment: .top) {
//            content
//            Rectangle()
//                .fill(Color.white).frame(height: 30)
//                .mask(LinearGradient(gradient:  Gradient(colors: [.white, .white.opacity(0)]), startPoint: .top, endPoint: .bottom)) //gradient 사라지게 어케주냐 아오옹먼ㅇㄹㅁㄴㅇㄹ
//            RoundedRectangle(cornerRadius: 2.5)
//                .frame(width: 40, height: 5.0)
//                .foregroundColor(Color.secondary)
//                .padding(10)
//
//        }
//        .frame(minWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height - 100) //modal full size
//        .background(Color.white).opacity(0.85)
//        .offset(y:  max(0, position + self.dragTracker.height))
//        .animation(dragging ? nil : {
//            Animation.interpolatingSpring(stiffness: 250.0, damping: 40.0, initialVelocity: 5.0)
//        }())
//        .gesture(DragGesture()
//            .updating($dragTracker) { drag, state, transaction in state = drag.translation }
//            .onChanged {_ in  dragging = true }
//            .onEnded(onDragEnded))
//    }
//
//    private func onDragEnded(drag: DragGesture.Value) {
//        dragging = false
//        let high = UIScreen.main.bounds.height - 400 //min height
//        let low: CGFloat = 50 //max height
//        let dragDirection = drag.predictedEndLocation.y - drag.location.y
//        //can also calculate drag offset to make it more rigid to shrink and expand
//        if dragDirection > 0 {
//            position = high
//        } else {
//            position = low
//        }
//    }
//}
//
//struct SlideOverView_Previews: PreviewProvider {
//    static var previews: some View {
//        ZStack{
//            CardContent()
//        }
//    }
//}
//
