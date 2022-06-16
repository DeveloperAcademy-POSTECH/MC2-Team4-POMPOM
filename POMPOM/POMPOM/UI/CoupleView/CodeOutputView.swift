//
//  CodeOutputView.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/06/09.
//

import SwiftUI

struct CodeOutputView: View {
    @Binding var code: String
    let afterCopy: () -> ()
    private let pasteboard = UIPasteboard.general
    private let codeViewModel: CodeViewModel = CodeViewModel()
    
    var body: some View {
        CodeView(title: "초대코드 확인", content: {
            Text(code)
                .task {
                    code = await codeViewModel.getCode()
                }
        }, buttonTitle: "복사") {
            pasteboard.string = code
            afterCopy()
        }
    }
}

struct CodeOutputView_Previews: PreviewProvider {
    static var previews: some View {
        CodeOutputView(code: .constant("ASDFGHDS")) {
            
        }
    }
}
