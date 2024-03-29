//
//  CoupleViewModel.swift
//  POMPOM
//
//  Created by 김남건 on 2022/07/07.
//

import Foundation
import SwiftUI

class MainViewModel: ObservableObject {
    @AppStorage("_isFirstLaunching") var isFirstLaunching: Bool = true
    @AppStorage("isConnectedPartner") var isConnectedPartnerStorage: Bool = false

    @Published var isConnectedPartner = false {
        didSet {
            isConnectedPartnerStorage = isConnectedPartner
        }
    }
    
    @Published var actionSheetPresented = false
    @Published var codeInput = ""
    @Published var commentInput = ""
    @Published var codeInputViewIsPresented = false
    @Published var codeOutputViewIsPresented = false
    @Published var sheetMode = SheetMode.none
    @Published var showAlert = false
    @Published var alertMessage: String = "유효하지 않은 동작입니다."
}
