//
//  CodeTemplateView.swift
//  POMPOM
//
//  Created by 김남건 on 2022/06/12.
//

import SwiftUI

struct CodeView<Content: View>: View {
    var fontSize: CGFloat {
        Constant.screenHeight * (20 / 844)
    }
    
    var textAreaWidth: CGFloat {
        Constant.screenWidth * (300 / 390)
    }
    
    var textAreaHeight: CGFloat {
        Constant.screenHeight * (56 / 844)
    }
    
    var buttonWidth: CGFloat {
        Constant.screenWidth * (80 / 390)
    }
    
    var buttonHeight: CGFloat {
        Constant.screenHeight * (40 / 844)
    }
    
    let title: String
    let content: () -> Content
    let buttonTitle: String
    let buttonAction: () -> ()
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGray4)
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .foregroundColor(Color.white)
                    
                VStack(spacing: 0) {
                    Text(title)
                        .font(.system(size: fontSize))
                        .padding(.bottom, Constant.screenHeight * (14 / 844))
                    content()
                        .font(.system(size: fontSize))
                        .frame(width: textAreaWidth, height: textAreaHeight)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .foregroundColor(Color(UIColor.systemGray5))
                        )
                        .padding(.bottom, Constant.screenHeight * (20 / 844))
                    Button(buttonTitle, action: buttonAction)
                    .frame(width: buttonWidth, height: buttonHeight)
                    .accentColor(.white)
                    .background(Color.blue)
                    .cornerRadius(5)
                }
            }
            .frame(height: Constant.screenHeight * (206 / 844))
            .padding(.horizontal, 8)
        }
        .edgesIgnoringSafeArea(.all)
        .frame(maxHeight: .infinity)
    }
}

struct CodeTemplateView_Previews: PreviewProvider {
    static var previews: some View {
        CodeView(title: "초대코드 확인", content: {
            Text("XEDAASDF")
        }, buttonTitle: "복사", buttonAction: {
            
        })
    }
}
