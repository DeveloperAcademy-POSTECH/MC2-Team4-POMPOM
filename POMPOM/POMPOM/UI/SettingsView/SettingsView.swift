//
//  SettingsView.swift
//  POMPOM
//
//  Created by DAEUN AN on 2022/06/16.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var actionSheetPresented = false
    @State private var codeInput = ""
    @State var showAlert = false
    @State var alertMessage: String = "유효하지 않은 동작입니다."
    
    var body: some View {
        ZStack {
            List {
                Section(header: Text("프로필 관리")) {
                    //Text("초대코드")를 CondeOutputView()로 변경
                    NavigationLink("초대코드 확인하기", destination: CodeOutputView(afterCopy: {}))
                    
                    //Text("초대코드 입력")을 CodeInputView()로 변경
                    NavigationLink("초대코드 입력하기", destination: CodeInputView(textInput: $codeInput, delegate: self, afterAction: {}))
                    
                    //"연결 해지" View 필요
                    Button("연결 해지") {
                        actionSheetPresented = true
                    }
                    .tint(Color(UIColor.label))
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("설정")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
            }))
            .confirmationDialog("친구 연결을 해지하시겠습니까?", isPresented: $actionSheetPresented) {
                Button("연결 해지", role: .destructive) {
                    // TODO: 연결 해지 로직 처리
                }
                .foregroundColor(Color(UIColor.label))
                
                Button("돌아가기", role: .cancel) {}
            }
            
            if showAlert {
                VStack {
                    CustomAlert(message: alertMessage, presenting: $showAlert)
                    Spacer()
                }
            }
        }
    }
}

extension SettingsView: NetworkDelegate {
    func showAlertwith(message: String) {
        alertMessage = message
        showAlert.toggle()
    }
    
    func didConnectedPartner() {
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView()
        }
    }
}
