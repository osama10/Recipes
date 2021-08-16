//
//  UIView+Extensions.swift
//  Task2
//
//  Created by Osama Bashir on 10/26/20.
//

import UIKit

extension UIView {
    func round() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.masksToBounds = true
    }
    
    func cardView( backgroundColor : UIColor , borderColor : UIColor , borderWidth : CGFloat , cornerRadius : CGFloat, shadowColor: UIColor = .themeColor, shadowOffset: CGSize = CGSize(width: 0, height: 1), opacity: Float = 0.5){
        self.backgroundColor = backgroundColor
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowOpacity = opacity
        self.layer.masksToBounds = false
    }
}

protocol ReusableView : AnyObject {  static var reuseIdentifier : String {get} }
extension ReusableView where Self : UIView {
    static var reuseIdentifier : String {
        return String(describing: self).components(separatedBy: ".").last!
    }
}

protocol NibLoadableView : AnyObject { static var nibName : String {get} }
extension NibLoadableView where Self : UIView {
    static var nibName : String {
        return String(describing: self).components(separatedBy: ".").last!
    }
    static func loadNib() -> Self {
        let bundle = Bundle(for:Self.self)
        let nib = UINib(nibName: Self.nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! Self
    }
}

