//
//  CodeInputView.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/06/09.
//

import SwiftUI

struct CodeInputView: View {
    @Binding var textInput: String
    var delegate: NetworkDelegate?
    private let codeManager: ConnectionManager = ConnectionManager()
    let afterAction: () -> ()
    
    var body: some View {
        CodeView(title: "초대코드 입력", content: {
            TextField("", text: $textInput)
                .padding(.horizontal, 8)
                .multilineTextAlignment(.center)
        }, buttonTitle: "확인", buttonAction: {
            Task {
                do {
                    try await codeManager.connectWithPartner(partnerCode: textInput)
                } catch ConnectionManagerResultType.success {
                    delegate?.didConnectedPartner()
                } catch ConnectionManagerResultType.callMySelf {
                    delegate?.showAlertwith(message: "자신의 코드는 입력할 수 없습니다.")
                } catch ConnectionManagerResultType.invalidPartnerCode {
                    delegate?.showAlertwith(message: "유효하지 않은 코드입니다.")
                }
            }
        }, afterAction: afterAction)
    }
}

struct CodeInputView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CodeInputView(textInput: .constant(""), afterAction: {})
                .navigationTitle("POMPOM")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
