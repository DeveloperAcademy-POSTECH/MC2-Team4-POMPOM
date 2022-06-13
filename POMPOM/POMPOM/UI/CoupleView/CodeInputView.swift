//
//  CodeInputView.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/06/09.
//

import SwiftUI

struct CodeInputView: View {
    @Binding var textInput: String
    let action: () -> ()
    
    var body: some View {
        CodeView(title: "초대코드 입력", content: {
            TextField("", text: _textInput)
                .padding(.horizontal, 8)
                .multilineTextAlignment(.center)
        }, buttonTitle: "확인", buttonAction: action)
    }
}

struct CodeInputView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CodeInputView(textInput: .constant("")) {
                
            }
                .navigationTitle("POMPOM")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
