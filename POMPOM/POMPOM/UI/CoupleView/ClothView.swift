//
//  ClothView.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/07/04.
//

import SwiftUI

struct ClothView: View {
    @ObservedObject var vm: ClothViewModel
    var body: some View {
        if !vm.mainImageString.isEmpty {
            ZStack {
                Image(vm.mainImageString)
                    .resizable()
                    .foregroundColor(Color(hex: vm.hex))
                
                Image(vm.strokeIamgeString)
                    .resizable()
                    .foregroundColor(Color(hex: vm.strokeHex))
            }
            .transition(.opacity)
        }
    }
}

struct ClothView_Previews: PreviewProvider {
    static var previews: some View {
        ClothView(vm: ClothViewModel(cloth: Cloth(id: "skirt", hex: "343434", category: .bottom), category: .bottom))
            .previewLayout(.fixed(width: 300, height: 300))
    }
}
