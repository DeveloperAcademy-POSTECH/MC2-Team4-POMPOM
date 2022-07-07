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
    @StateObject var myClothViewModel = PickerViewModel()
    @StateObject var partnerClothViewModel = ClothesViewModel()
    @StateObject var coupleViewModel = CoupleViewModel()
    var codeViewModel = CodeManager()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack(spacing: characterSpacing) {
                        if characterSize == .large {
                            Button {
                                coupleViewModel.actionSheetPresented = true
                            } label: {
                                ZStack {
                                    Image("Gom0")
                                        .resizable()
                                        .frame(width: characterWidth, height: characterHeight)
                                        .opacity(coupleViewModel.isConnectedPartner ? 1 : 0.3)
                                    
                                    if !coupleViewModel.isConnectedPartner {
                                        Text("초대하기")
                                            .foregroundColor(.orange)
                                    } else {
                                        ClothesView(vm: partnerClothViewModel)
                                    }
                                }
                                .frame(width: characterWidth, height: characterHeight)
                            }
                            .disabled(coupleViewModel.isConnectedPartner)
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
                    CardContent()
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
                
                Button {
                    myClothViewModel.clearSelectedItem()
                } label: {
                    Image(systemName: "gobackward")
                        .foregroundColor(Color(UIColor.label))
                        .font(.system(size: 24))
                }
                .frame(width: 44, height: 44)
                .opacity(0.3)
                .offset(x: resetButtonHorizontalPosition - 0.5 * Constant.screenWidth, y: resetButtonVerticalPosition  - 0.5 * Constant.screenHeight)
            }
            
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if coupleViewModel.sheetMode != .none {
                        Button("취소") {
                            Task {
                                await myClothViewModel.requestClothes()
                            }
                            coupleViewModel.sheetMode = .none
                        }
                        .foregroundColor(.red)
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
                        NavigationLink(destination:
                                        SettingsView(showAlert: $coupleViewModel.showAlert, alertMessage: $coupleViewModel.alertMessage, isPartnerConnected: $coupleViewModel.isConnectedPartner)
                        ) {
                            Image(systemName: "gearshape.fill")
                                .foregroundColor(Color(UIColor.label))
                        }
                    } else {
                        Button("완료") {
                            myClothViewModel.uploadItem()
                            coupleViewModel.sheetMode = .none
                            
                            Task {
                                await myClothViewModel.requestClothes()

                            }
                        }
                    }
                }
            }
            .actionSheet(isPresented: $coupleViewModel.actionSheetPresented) {
                ActionSheet(title: Text("초대코드 확인/입력"), buttons: [
                    .default(Text("초대코드 확인하기")) {
                        coupleViewModel.codeOutputViewIsPresented = true
                    },
                    .default(Text("초대코드 입력하기")) {
                        coupleViewModel.codeInputViewIsPresented = true
                        coupleViewModel.codeInput = ""
                    }, .cancel(Text("돌아가기"))])
            }
            .onAppear {
                codeViewModel.getCode()
                UITabBar.appearance().isHidden = true
                Task {
                    await myClothViewModel.requestClothes()
                    print("DEBUG: wow")
                }
                print(coupleViewModel.isFirstLaunching)
                Task {
                    await codeViewModel.getPartnerCodeFromServer { partnerCode in
                        print("DEBUG: getPartnerCodeFromServer completion")
                        if partnerCode == "" {
                            coupleViewModel.isConnectedPartner = false
                        } else {
                            print(partnerCode)
                            coupleViewModel.isConnectedPartner = true
                            Task {
                                await partnerClothViewModel.requestPartnerClothes()
                                print("DEBUG: partnerClothViewModel.requestPartnerClothes")
                            }
                        }
                    }
                }
            }
            
        }
        .fullScreenCover(isPresented: $coupleViewModel.isFirstLaunching) {
            OnboardingView(isFirstLunching: $coupleViewModel.isFirstLaunching)
        }
        .addCustomAlert(with: coupleViewModel.alertMessage, presenting: $coupleViewModel.showAlert)
    }
    
    //MARK: - Helpers
}

// MARK: - Computed properties related to layout
extension CoupleView {
    var characterSize: CharacterSize {
        switch coupleViewModel.sheetMode {
        case .none:
            return .large
        case .mid:
            return .medium
        case .high:
            return .small
        }
    }
    
    var resetButtonHorizontalPosition: CGFloat {
        switch coupleViewModel.sheetMode {
        case .none:
            return Constant.screenWidth + 44
        default:
            return Constant.screenWidth - 31
        }
    }
    
    var resetButtonVerticalPosition: CGFloat {
        Constant.screenHeight * (396 / 844) - 90
    }
    
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
}


//MARK: - Delegates
extension CoupleView: NetworkDelegate {
    func showAlertwith(message: String) {
        coupleViewModel.alertMessage = message
        coupleViewModel.showAlert.toggle()
    }
    
    func didConnectedPartner() {
        Task {
            await partnerClothViewModel.requestPartnerClothes()
        }
        coupleViewModel.isConnectedPartner = true
    }
}

protocol NetworkDelegate {
    func showAlertwith(message: String)
    func didConnectedPartner()
}

struct CoupleView_Previews: PreviewProvider {
    static var previews: some View {
        CoupleView()
    }
}


//MARK: - SubViews
struct ClothesView: View {
    @ObservedObject var vm: ClothesViewModel
    let zIndexIteration: [ClothCategory] = [.hat, .shoes, .bottom, .top]
    var body: some View {
        ZStack {
            ForEach(zIndexIteration) { category in
                let vm = ClothViewModel(cloth: vm.selectedItems[category], category: category)
                ClothView(vm: vm)
            }
            AccesoriesView(vm: vm)
        }
    }
}



struct AccesoriesView: View {
    @ObservedObject var vm: ClothesViewModel
    var body: some View {
        if vm.isValidItem(with: .accessories) {
            ZStack {
                Image(vm.fetchImageString(with: .accessories))
                    .resizable()
            }
            .transition(.slide)
        }
    }
}


