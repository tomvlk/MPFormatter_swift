//
//  MPColor.swift
//  MPFormatter
//
//  MIT Licensed, 2017, Tom Valk
//

import Foundation
import UIKit

class MPColor:MPStyles {
    
    fileprivate var color:UIColor
    
    init(color:UIColor, startIndex:Int){
        self.color = color
        
        super.init(start: startIndex)
    }
    
    func apply(_ attr:inout NSMutableAttributedString) {
        if(self.end != 0){
            attr.addAttribute(NSForegroundColorAttributeName, value: self.color, range: NSRange(location: self.start, length: self.end - self.start))
        }
    }
    
    class func isColor(_ input:String, startIndex:Int) -> MPColor? {
        if(input.characters.count == 3){
            return MPColor.init(color: UIColor(rgbaSmall: input), startIndex: startIndex)
        }
        return nil
    }
}

extension UIColor {
    convenience init(rgbaSmall: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        let alpha: CGFloat = 1.0
        
        if rgbaSmall.characters.count == 3 {
            let hex     = rgbaSmall
            let scanner = Scanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexInt64(&hexValue) {
                red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue  = CGFloat(hexValue & 0x00F)              / 15.0
            }
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}
