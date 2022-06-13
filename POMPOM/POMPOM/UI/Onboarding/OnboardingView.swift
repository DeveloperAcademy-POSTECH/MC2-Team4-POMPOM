//
//  OnboardingView.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/06/09.
//

import SwiftUI

struct OnboardingView: View {
    
    // CoupleView에 밑에 코드 추가
    //@AppStorage("_isFirstLanching") var isFirstLaunching: Bool = true
    
    //@Binding var isFirstLunching: Bool
    
    let onboardingViewData : [OnboardingViewModel] = [
        OnboardingViewModel(
            title: "내일 뭐 입고 올꺼야?",
            message: "커플 인생샷을 남기고 싶은데\n상대방이 무엇이 입고올지 고민인가요?",
            onboardingImage: "CuriousBear",
            isLast: false
        ),
        
        OnboardingViewModel(
            title: "코디 너로 결정!",
            message: "내 옷장에 색상을 넣고\n같이 컬러 조합을 맞춰봐요",
            onboardingImage: "ChooseClothes",
            isLast: false
        ),
        
        OnboardingViewModel(
            title: "함께 맞춰봐요",
            message: "상대방과 연결을 통해\n실시간으로 소통하며 확인해요",
            onboardingImage: "Connection",
            isLast: true
        )
    ]
    
    var body: some View {
        TabView {
            ForEach(onboardingViewData) {item in
                OnboardingPageView(onboardingViewModel: item)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
     }
}


struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
