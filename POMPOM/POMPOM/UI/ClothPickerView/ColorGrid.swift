//
//  ColorGrid.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/06/15.
//

import SwiftUI

struct ColorGrid: View {
    @ObservedObject var vm: PickerViewModel
    @Binding var currentHex: String
    
    let rows = [GridItem(.fixed(44), spacing: 20)]
    var body: some View {
        LazyHGrid(rows: rows, spacing: 18) {
            ForEach($vm.currentPresets, id: \.self) { item in
                ZStack {
                    Circle()
                        .fill(Color(hex: item.wrappedValue))
                        .frame(width: 44)
                        .shadow(radius: 5)
                        .onTapGesture {
                            withAnimation {
                                currentHex = item.wrappedValue
                                vm.changeColor(hex: currentHex)
                            }
                        }
                        .overlay {
                            if item.wrappedValue == vm.fetchCurrentHex() ?? currentHex {
                                Circle()
                                    .stroke(Color(hex: "BABABA"), lineWidth: 3)
                                    .frame(width: 60, height: 60, alignment: .center)
                            }
                        }
                }
            }
            Circle()
                .fill(Color(hex: "D8D8D8"))
                .frame(width: 44)
                .overlay(
                    Image(systemName: "plus")
                        .font(.title2)
                        
                )
                .onTapGesture {
                    print("DEBUG : Button tapped")
                    vm.addPreset(hex: "23F323")
                }
        }
    }
}


