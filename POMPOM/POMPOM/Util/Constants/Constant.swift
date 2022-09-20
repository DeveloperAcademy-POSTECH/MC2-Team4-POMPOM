//
//  Constant.swift
//  POMPOM
//
//  Created by 김남건 on 2022/06/11.
//

import Foundation
import UIKit

struct Constant {
    static var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    static var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    
    
}

enum URLPath: String  {
    private static let authURL = "https://pompom-ada.herokuapp.com/api/"
    
    case hello
    case signup
    case authenticate
    case pair
    case account
    
    var URLString: String {
        Self.authURL + self.rawValue
    }
}


