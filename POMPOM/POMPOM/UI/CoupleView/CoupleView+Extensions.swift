//
//  CoupleView+Extensions.swift
//  POMPOM
//
//  Created by 김남건 on 2022/07/07.
//

import Foundation
import SwiftUI

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
protocol NetworkDelegate {
    func showAlertwith(message: String)
    func didConnectedPartner()
}

extension CoupleView: NetworkDelegate {
    func showAlertwith(message: String) {
        coupleViewModel.alertMessage = message
        coupleViewModel.showAlert.toggle()
    }
    
    func didConnectedPartner() {
        partnerClothViewModel.listenPartnerClothes()
        coupleViewModel.isConnectedPartner = true
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

// MARK: - Computed properties of subviews
extension CoupleView {
    var partnerCharacterView: some View {
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
    
    var resetButton: some View {
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
    
    var settingsButton: some View {
        NavigationLink(destination:
                        SettingsView(showAlert: $coupleViewModel.showAlert, alertMessage: $coupleViewModel.alertMessage, isPartnerConnected: $coupleViewModel.isConnectedPartner)
        ) {
            Image(systemName: "gearshape.fill")
                .foregroundColor(Color(UIColor.label))
        }
    }
    
    var finishOutfitButton: some View {
        Button("완료") {
            coupleViewModel.sheetMode = .none
            Task {
                do {
                    try myClothViewModel.uploadItem()
                    try await myClothViewModel.requestClothes()
                } catch CodeError.noLocalCode {
                    print("ERROR: 로컬 코드 에러")
                } catch {
                    print("ERROR: \(error.localizedDescription)")
                }
            }
        }
    }
    
    var cancelOutfitButton: some View {
        Button("취소") {
            coupleViewModel.sheetMode = .none
            Task {
                try await myClothViewModel.requestClothes()
            }
        }
        .foregroundColor(.red)
    }
    
    var codeActionSheet: ActionSheet {
        ActionSheet(title: Text("초대코드 확인/입력"), buttons: [
            .default(Text("초대코드 확인하기")) {
                coupleViewModel.codeOutputViewIsPresented = true
            },
            .default(Text("초대코드 입력하기")) {
                coupleViewModel.codeInputViewIsPresented = true
                coupleViewModel.codeInput = ""
            }, .cancel(Text("돌아가기"))])
    }
}

// MARK: - methods
extension CoupleView {
    func connectPartner() {
        let code = codeViewModel.getCode()
        coupleViewModel.isConnectedPartner = true
        codeViewModel.addPartnerCodeListner(myCode: code) { partnerCode in
            if partnerCode == "" {
                coupleViewModel.isConnectedPartner = false
            } else {
                coupleViewModel.isConnectedPartner = true
                UserDefaults.standard.set(partnerCode, forKey: "partner_code")
                partnerClothViewModel.listenPartnerClothes()
            }
            
            print("대박 - \(partnerCode), \(coupleViewModel.isConnectedPartner)")
        }
    }
}
