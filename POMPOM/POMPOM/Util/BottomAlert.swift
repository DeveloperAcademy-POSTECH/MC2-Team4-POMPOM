//
//  BottomAlert.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/06/16.
//

import SwiftUI

struct BottomAlert: View {
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        presenting.toggle()
                    }
                }
            }
    }
}

struct BottomAlert_Previews: PreviewProvider {
    static var previews: some View {
        BottomAlert(message: "프리뷰 경고 메세지", presenting: .constant(true))
    }
}
