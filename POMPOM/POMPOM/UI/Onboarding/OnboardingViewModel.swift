//
//  OnboardingViewModel.swift
//  POMPOM
//
//  Created by 양원모 on 2022/06/13.
//

import SwiftUI

struct OnboardingViewModel: Identifiable {
    var id = UUID()
    var title: String
    var message: String
    var onboardingImage: String
    var ImageSpacer: CGFloat
    var isLast: Bool
}


