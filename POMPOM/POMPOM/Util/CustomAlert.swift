//
//  BottomAlert.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/06/16.
//

import SwiftUI

struct CustomAlert: View {
    var message: String
    @State var opacity: Double = 0.6
    @Binding var presenting: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.black.opacity(opacity))

            HStack {
                Text(message)
                    .foregroundColor(.white)
                    .padding(.leading, 20)

                Spacer()
            }
        }
        .frame(height: 50)
        .padding(.horizontal, 20)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    presenting = false
                }
            }
        }
    }
}

struct TopAlert: ViewModifier {
    var message: String
    @State var opacity: Double = 0.6
    @Binding var presenting: Bool

    func body(content: Content) -> some View {
        ZStack {
            content
            
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.black.opacity(opacity))
                    
                    HStack {
                        Text(message)
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                        
                        Spacer()
                    }
                }
                .frame(height: 50)
                .padding(.horizontal, 20)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            presenting = false
                        }
                    }
                }
                
                Spacer()
            }
        }
    }
}

extension View {
    func addCustomAlert(with message: String, presenting: Binding<Bool>) -> some View {
        modifier(TopAlert(message: message , presenting: presenting))
    }
}


struct BottomAlert_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlert(message: "프리뷰 경고 메세지", presenting: .constant(true))
    }
}
