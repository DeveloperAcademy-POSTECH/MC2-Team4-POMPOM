//
//  CoupleView.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/06/09.
//

import SwiftUI

enum CharacterSize {
    case large, medium, small
}

struct CoupleView: View {
    var characterSpacing: CGFloat {
        Constant.screenWidth * (33 / 390)
    }
    
    var characterWidth: CGFloat {
        switch characterSize {
        case .large:
            return Constant.screenWidth * (145 / 390)
        case .medium:
            return Constant.screenWidth * (114 / 390)
        case .small:
            return Constant.screenWidth * (54 / 390)
        }
    }
    
    var characterOffset: CGFloat {
        switch characterSize {
        case .large:
            return Constant.screenHeight * (93 / 844)
        case .medium:
            return Constant.screenHeight * (-29 / 844)
        case .small:
            return Constant.screenHeight * (-43 / 844)
        }
    }
    
    var characterHeight: CGFloat {
        characterWidth * (215.68 / 114)
    }
    
    @State private var partnerConnected = false
    @State private var actionSheetPresented = false
    @State private var codeInput = ""
    @State private var commentInput = ""
    @State private var codeInputViewIsPresented = false
    @State private var codeOutputViewIsPresented = false
    @State private var characterSize = CharacterSize.large
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: characterSpacing) {
                    if characterSize == .large {
                        Button {
                            actionSheetPresented = true
                        } label: {
                            ZStack {
                                Image("Character")
                                    .resizable()
                                    .frame(width: characterWidth, height: characterHeight)
                                    .opacity(partnerConnected ? 1 : 0.3)
                                
                                if !partnerConnected {
                                    Text("초대하기")
                                        .foregroundColor(.orange)
                                }
                            }
                        }
                        .disabled(partnerConnected)
                    }

                    Image("Character")
                        .resizable()
                        .frame(width: characterWidth, height: characterHeight)
                }
                .offset(y: characterOffset)
                .animation(.default, value: characterWidth)
                .animation(.default, value: characterHeight)
                .animation(.default, value: characterOffset)
                Spacer()
                CommentTextField(textInput: $commentInput)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("POMPOM")
                        .font(.custom("Montserrat-ExtraBold", size: 20))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: Text("Hello world")) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(Color(UIColor.label))
                    }
                }
            }
            .sheet(isPresented: $codeInputViewIsPresented, content: {
                CodeInputView(textInput: $codeInput)
            })
            .sheet(isPresented: $codeOutputViewIsPresented, content: {
                CodeOutputView(code: .constant("ASDFGHHH")) {
                    
                }
            })
            .actionSheet(isPresented: $actionSheetPresented) {
                ActionSheet(title: Text("초대코드 확인/입력"), buttons: [
                    .default(Text("초대코드 확인하기")) {
                    codeOutputViewIsPresented = true
                },
                    .default(Text("초대코드 입력하기")) {
                    codeInputViewIsPresented = true
                    codeInput = ""
                }, .cancel(Text("돌아가기"))])
            }
            .onAppear {
                UITabBar.appearance().isHidden = true
            }
        }
    }
}

struct CoupleView_Previews: PreviewProvider {
    static var previews: some View {
        CoupleView()
    }
}
