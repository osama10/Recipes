//
//  UIFont+Extensions.swift
//  Task2
//
//  Created by Osama Bashir on 10/26/20.
//

import UIKit

extension UIFont {
    enum FontSize {
        case standard(StandardSize)
        case custom(CGFloat)
        var value: CGFloat {
            switch self {
            case .standard(let size):
                return size.rawValue
            case .custom(let customSize):
                return customSize
            }
        }
    }

    enum FontName: String {
        case avenirRegular = "AvenirNext-Regular"
        case avenirBold = "AvenirNext-Bold"
    }

    enum StandardSize: CGFloat {
        case h1 = 24.0
        case h2 = 18.0
        case h3 = 16.0
        case text = 14.0
    }

    convenience init(_ name: FontName, size: FontSize) {
        self.init(name: name.rawValue, size: size.value)!
    }
}
