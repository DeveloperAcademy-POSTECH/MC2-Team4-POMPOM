//
//  CommentTextField.swift
//  POMPOM
//
//  Created by 김남건 on 2022/06/12.
//

import SwiftUI

struct CommentTextField: View {
    var buttonColor: Color {
        textInput.isEmpty ? Color(UIColor.systemGray2) : .orange
    }
    
    @Binding var textInput: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .foregroundColor(Color(UIColor.systemGray5))
            HStack(spacing: 17.8) {
                Rectangle()
                    .frame(width: 22.2, height: 16.28)
                    .padding(.leading, 18)
                TextField("코멘트를 입력하세요.", text: _textInput)
                    .font(.body)
                Button(action: {}) {
                    Image(systemName: "location.fill")
                        .foregroundColor(buttonColor)
                }
                .frame(width: 44, height: 44)
                .padding(.trailing, 5)
            }
        }
        .frame(height: 48)
    }
}

struct CommentTextField_Previews: PreviewProvider {
    static var previews: some View {
        CommentTextField(textInput: .constant(""))
    }
}
