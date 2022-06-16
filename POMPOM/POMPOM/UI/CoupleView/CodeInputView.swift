//
//  CodeInputView.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/06/09.
//

import SwiftUI

struct CodeInputView: View {
    @State var textInput: String = ""
    private let codeViewModel: CodeManager = CodeManager()
    
    var body: some View {
        CodeView(title: "초대코드 입력", content: {
            TextField("", text: $textInput)
                .padding(.horizontal, 8)
                .multilineTextAlignment(.center)
        }, buttonTitle: "확인", buttonAction: {
            Task {
                try await codeViewModel.connectWithPartner(partnerCode: textInput)
            }
        })
    }
}

struct CodeInputView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CodeInputView()
                .navigationTitle("POMPOM")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
