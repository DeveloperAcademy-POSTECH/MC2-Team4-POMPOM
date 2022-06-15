//
//  ClothPickerView.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/06/13.
//

import SwiftUI

struct ClothPickerView: View {
    @ObservedObject var vm: PickerViewModel
    @State var currentCategory = ClothCategory.hat
    @State var currentHex: String = "FFFFFF"

    
    var body: some View {
        VStack {
            CategoryGrid(vm: vm, currentHex: $currentHex, currentCategory: $currentCategory)
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
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        ColorGrid(vm: vm, currentHex: $currentHex)
                            .padding(.leading, 10)
                            .padding(10)
                        
                    }
                    
                    Seprator()
                        .padding(.bottom, 20)
                    
                    ClothGrid(vm: vm, currentCategory: $currentCategory, currentHex: $currentHex)
                        .padding(.horizontal, 20)
                }
            }
        }
    }
}

struct ClothPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ClothPickerView(vm: PickerViewModel())
    }
}


