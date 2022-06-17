//
//  BottomAlert.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/06/16.
//

import SwiftUI


struct TopAlert: ViewModifier {
    var message: String
    @State var opacity: Double = 0.6
    @Binding var presenting: Bool

    func body(content: Content) -> some View {
        
       
        ZStack {
            content
            
            
            if presenting {
                VStack {
                    
                    Spacer()
                        .frame(height: 60)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.black.opacity(opacity))
                        
                        HStack {
                            Text(message)
                                .font(.callout)
                                .foregroundColor(.white)
                                .padding(.leading, 20)
                            
                            Spacer()
                        }
                    }
                    .frame(height: 50)
                    .padding(.horizontal, 20)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                presenting = false
                            }
                        }
                    }
                    
                    Spacer()
                }
                .allowsHitTesting(false) // 터치 불가
            }
        }
    }
}

extension View {
    func addCustomAlert(with message: String, presenting: Binding<Bool>) -> some View {
        modifier(TopAlert(message: message , presenting: presenting))
    }
}


