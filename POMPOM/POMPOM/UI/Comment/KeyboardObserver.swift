//
//  KeyboardObserver.swift
//  POMPOM
//
//  Created by jiin on 2022/06/15.
//

//https://en.swiswiswift.com/2020-02-28/

import SwiftUI

class KeyboardObserver: ObservableObject {
    @Published var isShowing = false
    @Published var height: CGFloat = 0
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self,name: UIResponder.keyboardWillShowNotification,object: nil)
        NotificationCenter.default.removeObserver(self,name: UIResponder.keyboardWillHideNotification,object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        isShowing = true
        guard let userInfo = notification.userInfo as? [String: Any] else {
            return
        }
        guard let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardSize = keyboardInfo.cgRectValue.size
        height = keyboardSize.height
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        isShowing = false
        height = 0
    }
}
