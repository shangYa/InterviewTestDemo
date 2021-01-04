//
//  Global.swift
//  InterviewTestDemo
//
//  Created by NewApple on 2021/1/4.
//

import UIKit

let kHostName = ""
let endpoint = "https://api.github.com"

let black = 0x333333.asUIColor()
let blue = 0x339BFF.asUIColor()
let lightGray = 0xF8F8F8.asUIColor()
let gray = 0x999999.asUIColor()

let screenW = UIScreen.main.bounds.width
let screenH = UIScreen.main.bounds.height
let onePixel: CGFloat = 1.0 / UIScreen.main.scale

struct G {
    static func statusHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            if let statusBarManager = UIApplication.shared.windows.first?.windowScene?.statusBarManager {
                statusBarHeight = statusBarManager.statusBarFrame.size.height
            }else{
                statusBarHeight = UIApplication.shared.statusBarFrame.size.height
            }
        }
        else {
            statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        }
        print("状态栏高度:\(statusBarHeight)")

        return statusBarHeight
    }
    static func safeAreaHeight() -> CGFloat {
        if self.statusHeight() > 20 {
            return 34
        }
        return 0
    }
    static func color(_ normal: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (coll) -> UIColor in
                if coll.userInterfaceStyle == .dark {
                    return dark
                }
                return normal
            }
        } else {
            return normal
        }
    }
}
