//
//  CodeInputView.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/06/09.
//

import SwiftUI

struct CodeInputView: View {
    @Binding var textInput: String
    var delegate: AlertDelegate?
    private let codeViewModel: CodeManager = CodeManager()
    
    var body: some View {
        CodeView(title: "초대코드 입력", content: {
            TextField("", text: $textInput)
                .padding(.horizontal, 8)
                .multilineTextAlignment(.center)
        }, buttonTitle: "확인", buttonAction: {
            Task {
                do {
                    try await codeViewModel.connectWithPartner(partnerCode: textInput)
                } catch ConnectionManagerError.invalidPartnerCode {
                    delegate?.showAlertwith(message: "유효하지 않은 코드입니다.")
                }
            }
        })
    }
}

struct CodeInputView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CodeInputView(textInput: .constant(""))
                .navigationTitle("POMPOM")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
