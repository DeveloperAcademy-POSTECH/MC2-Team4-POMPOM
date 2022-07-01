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
    @AppStorage("isConnectedPartner") var isConnectedPartnerStorage: Bool = false

    @State var isConnectedPartner = false {
        didSet {
            isConnectedPartnerStorage = isConnectedPartner
        }
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
    
    @StateObject var myClothViewModel = PickerViewModel()
    @StateObject var partnerClothViewModel = ClothViewModel()
    var codeViewModel = CodeManager()
    @State private var actionSheetPresented = false
    @State private var codeInput = ""
    @State private var commentInput = ""
    @State private var codeInputViewIsPresented = false
    @State private var codeOutputViewIsPresented = false
    @State private var sheetMode = SheetMode.none
    @State var showAlert = false
    @State var alertMessage: String = "유효하지 않은 동작입니다."
    
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
    
    var resetButtonHorizontalPosition: CGFloat {
        switch sheetMode {
        case .none:
            return Constant.screenWidth + 44
        default:
            return Constant.screenWidth - 31
        }
    }
    
    var resetButtonVerticalPosition: CGFloat {
        Constant.screenHeight * (396 / 844) - 90
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
                                        .opacity(isConnectedPartner ? 1 : 0.3)
                                    
                                    if !isConnectedPartner {
                                        Text("초대하기")
                                            .foregroundColor(.orange)
                                    } else {
                                        ClothesView(vm: partnerClothViewModel)
                                    }
                                }
                                .frame(width: characterWidth, height: characterHeight)
                            }
                            .disabled(isConnectedPartner)
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
                }
                
                

                if sheetMode == .none && isConnectedPartner {
                    CardContent()
                }
                
                SheetView(sheetMode: $sheetMode) {
                    ClothPickerView(vm: myClothViewModel)
                }
                
                if codeInputViewIsPresented {
                    CodeInputView(textInput: $codeInput, delegate: self) {
                        codeInputViewIsPresented = false
                    }
                }
                
                if codeOutputViewIsPresented {
                    CodeOutputView {
                        codeOutputViewIsPresented = false
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
                        NavigationLink(destination:
                                        SettingsView(showAlert: $showAlert, alertMessage: $alertMessage, isPartnerConnected: $isConnectedPartner)
                        ) {
                            Image(systemName: "gearshape.fill")
                                .foregroundColor(Color(UIColor.label))
                        }
                    } else {
                        Button("완료") {
                            myClothViewModel.uploadItem()
                            sheetMode = .none
                            
                            Task {
                                await myClothViewModel.requestClothes()

                            }
                        }
                    }
                }
            }
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
                codeViewModel.getCode()
                UITabBar.appearance().isHidden = true
                Task {
                    await myClothViewModel.requestClothes()
                    print("DEBUG: wow")
                }
                print(isFirstLaunching)
                Task {
                    await codeViewModel.getPartnerCodeFromServer { partnerCode in
                        print("DEBUG: getPartnerCodeFromServer completion")
                        if partnerCode == "" {
                            self.isConnectedPartner = false
                        } else {
                            print(partnerCode)
                            self.isConnectedPartner = true
                            Task {
                                await partnerClothViewModel.requestPartnerClothes()
                                print("DEBUG: partnerClothViewModel.requestPartnerClothes")
                            }
                        }
                    }
                }
            }
            
        }
        .fullScreenCover(isPresented: $isFirstLaunching) {
            OnboardingView(isFirstLunching: $isFirstLaunching)
        }
        .addCustomAlert(with: alertMessage, presenting: $showAlert)
    }
    
    //MARK: - Helpers
}


//MARK: - Delegates
extension CoupleView: NetworkDelegate {
    func showAlertwith(message: String) {
        alertMessage = message
        showAlert.toggle()
    }
    
    func didConnectedPartner() {
        Task {
            await partnerClothViewModel.requestPartnerClothes()
        }
        isConnectedPartner = true
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
    @ObservedObject var vm: ClothViewModel
    let iteration: [ClothCategory] = [.hat, .shoes, .bottom, .top]
    var body: some View {
        ZStack {
            ForEach(iteration) { category in
                let vm = ClothCombineViewModel(cloth: vm.selectedItems[category], category: category)
                ClothView(vm: vm)
            }
            AccesoriesView(vm: vm)
        }
    }
}

struct ClothView: View {
    @ObservedObject var vm: ClothCombineViewModel
    var body: some View {
        if !vm.mainImageString.isEmpty {
            ZStack {
                Image(vm.mainImageString)
                    .resizable()
                    .foregroundColor(Color(hex: vm.hex))
                
                Image(vm.strokeIamgeString)
                    .resizable()
                    .foregroundColor(Color(hex: vm.strokeHex))
            }
            .transition(.opacity)
        }
    }
}

struct AccesoriesView: View {
    @ObservedObject var vm: ClothViewModel
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


