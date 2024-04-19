//
//  ColorExtention.swift
//  BRTask
//
//  Created by Ilahe Samedova on 18.04.24.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let one, two, three, four: UInt64
        switch hex.count {
        case 3:
            (one, two, three, four) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (one, two, three, four) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (one, two, three, four) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (one, two, three, four) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(two) / 255, green: CGFloat(three)
                  / 255, blue: CGFloat(four) / 255, alpha: CGFloat(one) / 255)
    }
    static var mainColor: UIColor { UIColor(hexString: "2871E6") }
    static var grayColor: UIColor {UIColor (hexString: "D9D9D9")}

}
