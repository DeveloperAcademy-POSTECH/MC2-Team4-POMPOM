//
//  POMPOMApp.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/06/03.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth



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
}


@main
struct POMPOMApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            CoupleView()
        }
    }
}
