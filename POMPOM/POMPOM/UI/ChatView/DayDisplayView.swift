//
//  DayDisplayView.swift
//  POMPOM
//
//  Created by 양원모 on 2022/06/17.
//

import SwiftUI

struct DateDisplayView: View {
    var body: some View {
        Text(KoreanDate())
            .font(.system(size: 12))
            .padding([.bottom, .top], 6)
            .padding([.trailing, .leading], 12)
            .foregroundColor( Color.white)
            .background(Color(UIColor(red: 209/255, green: 209/255, blue: 214/255, alpha: 1.0)))
            .cornerRadius(20)
    }
    
    func KoreanDate() -> String {
        let todayKR = Date()
        let formatter = DateFormatter()
        
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.dateFormat = "yyyy년 MM월 dd일"
        
        return formatter.string(from: todayKR)
    }
    //https://hururuek-chapchap.tistory.com/156
    
}


struct DateDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        DateDisplayView()
    }
}
