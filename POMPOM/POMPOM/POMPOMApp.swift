//
//  POMPOMApp.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/06/03.
//

import SwiftUI
import FirebaseCore
//import FirebaseAuth



class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
////        FirebaseApp.configure()
//        //로그인 되었는 지 확인
//        if let user = Auth.auth().currentUser {
//            print("You're sign in as \(user.uid), email: \(user.email ?? "no email")")
//        }
        
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in

                // If granted comes true you can enabled features based on authorization.
                guard granted else { return }

                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
            return true
        }
        
        func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            
            let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
            print(token)
        }
        
        func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {

            print("i am not available in simulator :( \(error)")
        }
        
        return true
    }
}


@main
struct POMPOMApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    init() {
        FirebaseApp.configure()
    }
    

    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
