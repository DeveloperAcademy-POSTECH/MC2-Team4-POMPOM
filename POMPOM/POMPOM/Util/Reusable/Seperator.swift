//
//  SeperatorView.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/06/15.
//

import SwiftUI

struct Seprator: View {
    var body: some View {
        Rectangle()
            .fill(Color(hex: "D8D8D8"))
            .frame(height: 0.75)
    }
}

struct SeperatorView_Previews: PreviewProvider {
    static var previews: some View {
        Seprator()
    }
}
