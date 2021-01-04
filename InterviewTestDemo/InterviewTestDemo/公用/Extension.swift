//
//  extension.swift
//  InterviewTestDemo
//
//  Created by NewApple on 2021/1/4.
//

import UIKit

extension Int {
    func asUIColor() -> UIColor {
        return UIColor(red: CGFloat((self & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((self & 0x00FF00) >> 8) / 255.0,
                       blue: CGFloat((self & 0x0000FF) >> 0) / 255.0,
                       alpha: 1.0)
    }
    func plain() -> UIFont {
      
        return UIFont(name: "PingFangSC-Regular", size: CGFloat(self)) ??
             UIFont.systemFont(ofSize: CGFloat(self))
    
     
    }

}
extension UILabel {
    convenience init(_ text: String, font: UIFont = 15.plain(), color: UIColor = black,dark: UIColor = .white) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = G.color(color, dark: dark)
        self.numberOfLines = 0
    }
 
}

extension UIButton {

    @discardableResult
    func normalTitle( _ title: String) -> Self {
        self.setTitle(title, for: .normal)
        return self
    }
    @discardableResult
    func normalTitleColor( _ color: UIColor) -> Self {
        self.setTitleColor(color, for: .normal)
        return self
    }
    @discardableResult
    func font( _ font: UIFont) -> Self {
        self.titleLabel?.font = font
        return self
    }
}
