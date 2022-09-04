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

struct MainView: View {
    @AppStorage("_isFirstLaunching") var isFirstLaunching: Bool = true
    @AppStorage("isConnectedPartner") var isConnectedPartnerStorage: Bool = false

    @State var isConnectedPartner = false {
        didSet {
            isConnectedPartnerStorage = isConnectedPartner
        }
    }
    
    @StateObject var myClothViewModel = PickerCombineViewModel()
    @StateObject var partnerClothViewModel = ClothesViewModel()
    @StateObject var coupleViewModel = MainViewModel()
    var codeViewModel = CodeManager()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack(spacing: characterSpacing) {
                        if characterSize == .large {
                            partnerCharacterView
                        }
                        ZStack {
                            Image("Gom0")
                                .resizable()
                            ClothesView(vm: myClothViewModel)
                        }
                        .frame(width: characterWidth, height: characterHeight)
                        .onTapGesture {
                            withAnimation {
                                coupleViewModel.sheetMode = .mid
                            }
                        }
                    }
                    .offset(y: characterOffset)
                    .animation(.default, value: characterWidth)
                    .animation(.default, value: characterHeight)
                    .animation(.default, value: characterOffset)
                    Spacer()
                }
                
                if coupleViewModel.sheetMode == .none && coupleViewModel.isConnectedPartner {
                    CommentsView()
                }
                
                SheetView(sheetMode: $coupleViewModel.sheetMode) {
                    ClothPickerView(vm: myClothViewModel)
                }
                
                if coupleViewModel.codeInputViewIsPresented {
                    CodeInputView(textInput: $coupleViewModel.codeInput, delegate: self) {
                        coupleViewModel.codeInputViewIsPresented = false
                    }
                }
                
                if coupleViewModel.codeOutputViewIsPresented {
                    CodeOutputView {
                        coupleViewModel.codeOutputViewIsPresented = false
                    }
                }
                
                resetButton
            }
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if coupleViewModel.sheetMode != .none {
                        cancelOutfitButton
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    if coupleViewModel.sheetMode == .none {
                        Text("POMPOM")
                            .font(.custom("Montserrat-ExtraBold", size: 20))
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if coupleViewModel.sheetMode == .none {
                        settingsButton
                    } else {
                        finishOutfitButton
                    }
                }
            }
            .actionSheet(isPresented: $coupleViewModel.actionSheetPresented) {
                codeActionSheet
            }
            .onAppear {
                connectPartner()
            }
            
        }
        .fullScreenCover(isPresented: $coupleViewModel.isFirstLaunching) {
            OnboardingView(isFirstLunching: $coupleViewModel.isFirstLaunching)
        }
        .addCustomAlert(with: coupleViewModel.alertMessage, presenting: $coupleViewModel.showAlert)
    }
}

struct CoupleView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
