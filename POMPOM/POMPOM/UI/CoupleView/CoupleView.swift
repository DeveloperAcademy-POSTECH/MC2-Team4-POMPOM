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
    @AppStorage("_isFirstLaunching") var isFirstLaunching: Bool = true
    
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
    
    @StateObject var myClothViewModel = PickerViewModel()
    @StateObject var partnerClothViewModel = ClothViewModel()
    var codeViewModel = CodeManager()
    @State private var partnerConnected = false
    @State private var actionSheetPresented = false
    @State private var codeInput = ""
    @State private var commentInput = ""
    @State private var codeInputViewIsPresented = false
    @State private var codeOutputViewIsPresented = false
    @State private var sheetMode = SheetMode.none
    
    var characterSize: CharacterSize {
        switch sheetMode {
        case .none:
            return .large
        case .mid:
            return .medium
        case .high:
            return .small
        }
    }
    
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack(spacing: characterSpacing) {
                        if characterSize == .large {
                            Button {
                                actionSheetPresented = true
                            } label: {
                                ZStack {
                                    Image("Gom0")
                                        .resizable()
                                        .frame(width: characterWidth, height: characterHeight)
                                        .opacity(partnerConnected ? 1 : 0.3)
                                    
                                    if !partnerConnected {
                                        
                                        Text("초대하기")
                                            .foregroundColor(.orange)
                                    } else {
                                        ClothesView(vm: partnerClothViewModel)
                                    }
                                }
                            }
                            .disabled(partnerConnected)
                        }
                        
                        ZStack {
                            Image("Gom0")
                                .resizable()

                            ClothesView(vm: myClothViewModel)

                        }
                        .frame(width: characterWidth, height: characterHeight)
                        .onTapGesture {
                            withAnimation {
                                sheetMode = .mid
                            }
                        }
                    }
                    .offset(y: characterOffset)
                    .animation(.default, value: characterWidth)
                    .animation(.default, value: characterHeight)
                    .animation(.default, value: characterOffset)
                    Spacer()
                    CommentTextField(textInput: $commentInput)
                }
                
                SheetView(sheetMode: $sheetMode) {
                    ClothPickerView(vm: myClothViewModel)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if sheetMode != .none {
                        Button("취소") {
                            Task {
                                await myClothViewModel.requestClothes()
                            }
                            sheetMode = .none
                        }
                        .foregroundColor(.red)
                    }
                }
      
                
                ToolbarItem(placement: .principal) {
                    if sheetMode == .none {
                        Text("POMPOM")
                            .font(.custom("Montserrat-ExtraBold", size: 20))
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if sheetMode == .none {
                        NavigationLink(destination: Text("Hello world")) {
                            Image(systemName: "gearshape.fill")
                                .foregroundColor(Color(UIColor.label))
                        }
                    } else {
                        Button("완료") {
                            myClothViewModel.uploadItem()
                            sheetMode = .none
                        }
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
                Task {
                    await myClothViewModel.requestClothes()
                    await partnerClothViewModel.requestClothes()
                }
                print(isFirstLaunching)
                
            }
            
        }        .fullScreenCover(isPresented: $isFirstLaunching) {
            OnboardingView(isFirstLunching: $isFirstLaunching)
        }
    }
}

struct CoupleView_Previews: PreviewProvider {
    static var previews: some View {
        CoupleView()
    }
}

struct ClothView: View {
    @ObservedObject var vm: ClothViewModel
    var category: ClothCategory
    
    var body: some View {
        ZStack {
            Image(vm.fetchImageString(with: category) + "B")
                .resizable()
                .foregroundColor(Color(hex: vm.selectedItems[category]?.hex ?? "FFFFFF"))
            
            Image(vm.fetchImageString(with: category))
                .resizable()
                .foregroundColor(Color(hex: vm.selectedItems[category]?.hex ?? "FFFFFF" == "000000" ? "D0D0D0" : "000000"))
        }
    }
}

struct AccesoriesView: View {
    @ObservedObject var vm: ClothViewModel
   
    var body: some View {
        ZStack {
            Image(vm.fetchImageString(with: .accessories))
                .resizable()
        }
    }
}

struct ClothesView: View {
    @ObservedObject var vm: ClothViewModel
    
    var body: some View {
        ZStack {
            ClothView(vm: vm, category: .hat)
            ClothView(vm: vm, category: .shoes)
            ClothView(vm: vm, category: .bottom)
            AccesoriesView(vm: vm)
            ClothView(vm: vm, category: .top)
        }
    }
}

