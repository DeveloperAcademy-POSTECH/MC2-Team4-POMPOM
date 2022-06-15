//
//  SettingsView.swift
//  POMPOM
//
//  Created by DAEUN AN on 2022/06/14.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        List {
            Section(header: Text("프로필 관리")) {
                NavigationLink("초대코드 확인하기", destination: Text("초대코드 확인하기"))
                
                NavigationLink("초대코드 입력하기", destination: Text("초대코드 입력하기"))
                
                NavigationLink("연결 해지", destination: Text ("연결 해지"))
                
            }
        }
    }
}
    

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView()
                .navigationTitle("설정")
                .navigationBarTitleDisplayMode(.inline)
                
        }
    }
}
