//
//  ColorPickerView.swift
//  POMPOM
//
//  Created by 양원모 on 2022/06/15.
//

import SwiftUI

struct ColorPickerView: View {
    @Binding var selectColor: Color
    
    var body: some View {
        ColorPicker("색 선택 후 X 버튼 클릭", selection: _selectColor,supportsOpacity: false)
            .labelsHidden()
            .overlay(
                Circle()
                    .fill(Color(hex: "D8D8D8"))
                    .frame(width: 44, height: 44)
                    .overlay(
                        Image(systemName: "plus")
                            .font(.title2)
                    )
                    .allowsHitTesting(false)
            )
    }
}

struct ColorPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPickerView(selectColor: .constant(.black))
    }
}

//https://stackoverflow.com/questions/67145122/how-can-i-change-layout-of-apple-colorpicker-from-circle-to-square-in-swiftui

