//
//  Foundation+.swift
//  Countdown App
//
//  Created by Алексей Павленко on 27.08.2022.
//

import UIKit

extension Int {
    func appendZeros() -> String {
        if self < 10 {
            return "0\(self)"
        } else {
            return "\(self)"
        }
    }
}

extension Double {
    func degreeToRadians() -> CGFloat {
        return CGFloat(self * .pi) / 180
    }
}
