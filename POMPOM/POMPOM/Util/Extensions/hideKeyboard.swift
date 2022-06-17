//
//  hideKeyboard.swift
//  POMPOM
//
//  Created by jiin on 2022/06/17.
//
//https://seons-dev.tistory.com/entry/CODE-%ED%83%AD%ED%95%98%EC%97%AC-%ED%82%A4%EB%B3%B4%EB%93%9C-%EC%88%A8%EA%B8%B0%EB%8A%94%EB%B0%A9%EB%B2%95-hideKeyboard

import Foundation
import SwiftUI
 
extension UIApplication {
    func hideKeyboard() {
        guard let window = windows.first else { return }
        let tapRecognizer = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapRecognizer.cancelsTouchesInView = false
        tapRecognizer.delegate = self
        window.addGestureRecognizer(tapRecognizer)
    }
 }
 
extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
