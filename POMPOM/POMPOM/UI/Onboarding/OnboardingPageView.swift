//
//  OnboardingPageView.swift
//  POMPOM
//
//  Created by 양원모 on 2022/06/13.
//

import SwiftUI

struct OnboardingPageView: View {
    var onboardingViewModel: OnboardingViewModel
    @Binding var isFirstLunching: Bool
    
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: Constant.screenHeight * (84 / 844))
            Text(onboardingViewModel.title)
                .font(.system(size: 30, weight: .heavy))
                .frame(height: Constant.screenHeight * (20 / 844))
                .padding(17)
            Text(onboardingViewModel.message)
                .font(.system(size: 17))
                .multilineTextAlignment(.center)
                .lineSpacing(6)
            Spacer()
                .frame(height: Constant.screenHeight * (60 / 844))
            HStack {
                Spacer()
                Image(onboardingViewModel.onboardingImage)
                    .resizable()
                    .frame(width: onboardingViewModel.onboardingWidth, height: onboardingViewModel.onboardingHeight)
                    
                Spacer()
            }
            Spacer()
            if onboardingViewModel.isLast {
                Button(action: {
                    isFirstLunching = false
                            }) {
                                Text("시작하기")
                                    .padding()
                                    .frame(width: Constant.screenWidth * (302 / 390), height: Constant.screenHeight * (50 / 844))
                                    .foregroundColor(.white)
                                    .background(Color.black)
                                    .cornerRadius(8)
                            }
                            .padding(20)
                            Spacer()
                                .frame(height: Constant.screenHeight * (40 / 844))

            }
         }
     }
}

//struct OnboardingPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingPageView(onboardingViewModel: OnboardingViewModel(
//            title: "코디 너로 결정!",
//            message: "내 옷장에 색상을 넣고\n같이 컬러 조합을 맞춰봐요",
//            onboardingImage: "ChooseClothes",
//            isLast: false))
//    }
//}

