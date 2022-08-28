//
//  Constants.swift
//  Countdown App
//
//  Created by Алексей Павленко on 27.08.2022.
//

import UIKit

struct Constants {
    //MARK: - Variables    
    static var hasTopNotch: Bool {
        guard #available(iOS 11, *), let window = UIApplication.shared.keyWindow else {return false}
        return window.safeAreaInsets.top >= 44
    }
}
