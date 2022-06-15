//
//  ClothGrid.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/06/15.
//

import SwiftUI

struct ClothGrid: View {
    @ObservedObject var vm: PickerViewModel
    @Binding var currentCategory: ClothCategory
    @Binding var currentHex: String
    
    let columns = [
        GridItem(.flexible(minimum: 60), spacing: 20),
        GridItem(.flexible(minimum: 60), spacing: 20)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach($vm.currentItems, id: \.self) { item in
                ZStack {
                    Image(vm.imageName(name: item.wrappedValue) + "B")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .foregroundColor(Color(hex: vm.fetchCurrentHex() ?? currentHex)) // ‼️ 카테고리 변경후 tap 시 색이 다시 빠지는 현상 발생 -> 객체 자체가 변경되기 때문이 아닐까?
                    
                    Image(vm.imageName(name: item.wrappedValue))
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .foregroundColor(currentHex == "000000" ? .gray : .black) // 검정색일 때 옷 테두리 색상 변경
                        .overlay {
                            if vm.currentItem?.id == item.wrappedValue {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color(hex: "BABABA"), lineWidth: 4)
                                    .frame(width: 180, height: 180, alignment: .center)
                            }
                        }
                }
                .onTapGesture {
                    withAnimation {
                        vm.selectItem(name: item.wrappedValue, hex: vm.fetchCurrentHex() ?? currentHex)
                    }
                }
            }
        }
    }
}

