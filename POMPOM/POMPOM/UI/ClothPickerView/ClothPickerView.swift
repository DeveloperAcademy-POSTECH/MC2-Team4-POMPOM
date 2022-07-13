//
//  ClothPickerView.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/06/13.
//

import SwiftUI

struct ClothPickerView: View {
    @ObservedObject var vm: PickerCombineViewModel
    @State var currentCategory = ClothCategory.hat
    @State var currentHex: String = "FFFFFF"
    @State var offSet: CGFloat = Constant.screenWidth / 2 - 60
    
    var body: some View {
        VStack {
            categoryGrid
                .frame(width: Constant.screenWidth, height: 50)
                
            
            Seprator()
            
            ScrollView(showsIndicators: false) {
                VStack {
                    
                    HStack {
                        Text("내 옷장")
                            .font(.custom("none", size: 15))
                        Spacer()
                    }
                    .padding(.leading, 20)
                    .padding(.top, 15)
                    
                    if vm.isColorEnable {
                        ScrollView(.horizontal, showsIndicators: false) {
                            colorPresetGrid
                                .padding(.leading, 10)
                                .padding(10)
                        }
                    }
                    
                    Seprator()
                        .padding(.bottom, 20)
                    
                    clothesGrid
                        .padding(.horizontal, 20)
                }
            }
        }
    }
}

extension ClothPickerView {
    var categoryGrid: some View {
        LazyHGrid(rows: [GridItem(.fixed(44))], spacing: 40) {
            ForEach(ClothCategory.allCases) { category in
                Text(category.koreanSubtitle)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(category == vm.currentCategory ? Color(hex: "FF5100") : Color(hex: "A0A0A0"))
                    .onTapGesture {
                        // 맥락 바꾸기.
                        vm.setCategory(category)
                        let spacing: CGFloat = 60
                        withAnimation(.spring()) {
                            switch vm.currentCategory {
                            case .hat:
                                offSet = Constant.screenWidth / 2 - spacing
                            case .top:
                                offSet = Constant.screenWidth / 2 - spacing * 2
                            case .bottom:
                                offSet = Constant.screenWidth / 2 - spacing * 3
                            case .shoes:
                                offSet = Constant.screenWidth / 2 - spacing * 4
                            case .accessories:
                                offSet = Constant.screenWidth / 2 - spacing * 5
                            }
                        }
                        currentCategory = category
                    }
            }
            .offset(x: offSet, y: 0)
        }
    }
    
    var colorPresetGrid: some View {
        LazyHGrid(rows: [GridItem(.fixed(44), spacing: 20)], spacing: 18) {
            ForEach($vm.currentPresets, id: \.self) { item in
                ZStack {
                    Circle()
                        .fill(Color(hex: item.wrappedValue))
                        .frame(width: 44)
                        .shadow(radius: 5)
                        .overlay {
                            if item.wrappedValue == vm.currentHex {
                                Circle()
                                    .stroke(Color(hex: "BABABA"), lineWidth: 3)
                                    .frame(width: 60, height: 60, alignment: .center)
                            } else {
                                EmptyView()
                            }
                        }
                        .onTapGesture {
                            withAnimation {
                                vm.setColor(withHex: item.wrappedValue)
                            }
                        }
                }
            }
        }
    }
    
    var clothesGrid: some View {
        LazyVGrid(columns:  [
            GridItem(.flexible(minimum: 60), spacing: 20),
            GridItem(.flexible(minimum: 60), spacing: 20)
        ], spacing: 20) {
            ForEach($vm.currentItems, id: \.self) { item in
                ZStack {
                    Image(vm.fetchImageString(withName: item.wrappedValue) + "B")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .foregroundColor(Color(hex: vm.currentHex)) // ‼️ 카테고리 변경후 tap 시 색이 다시 빠지는 현상 발생 -> 객체 자체가 변경되기 때문이 아닐까?
                    
                    Image(vm.fetchImageString(withName: item.wrappedValue))
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .foregroundColor(vm.currentHex == "000000" ? .gray : .black)
                        .overlay(
//                            if vm.selectedItems[vm.currentCategory] == item.wrappedValue {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color(hex: "BABABA"), lineWidth: 4)
                                    .frame(width: 180, height: 180, alignment: .center)
//                            }
                        )
                        .onTapGesture {
                            withAnimation {
                                vm.selectItem(name: item.wrappedValue)
                            }
                        }
                }
            }
        }
    }
}

struct ClothPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ClothPickerView(vm: PickerCombineViewModel())
    }
}
