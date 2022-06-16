//
//  CodeOutputView.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/06/09.
//

import SwiftUI

struct CodeOutputView: View {
    let code: String = CodeManager().getCode()
    let afterCopy: () -> () = { }
    private let pasteboard = UIPasteboard.general
    private let codeViewModel: CodeManager = CodeManager()
    
    var body: some View {
        CodeView(title: "초대코드 확인", content: {
            Text(code)
        }, buttonTitle: "복사") {
            pasteboard.string = code
            afterCopy()
        }
    }
}

struct CodeOutputView_Previews: PreviewProvider {
    static var previews: some View {
        CodeOutputView()
    }
}
