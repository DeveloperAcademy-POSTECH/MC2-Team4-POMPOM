//
//  POMPOMApp.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/06/03.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        //로그인 되었는 지 확인
        if let user = Auth.auth().currentUser {
            print("You're sign in as \(user.uid), email: \(user.email ?? "no email")")
        }
        return true
    }
    
    // 인증 절차의 마지막에 받은 URL을 처리하기 위해서 필요한 메서드입니다.
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any])
      -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
}


@main
struct POMPOMApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            //ContentView()
            CardContent()
        }
    }
}
