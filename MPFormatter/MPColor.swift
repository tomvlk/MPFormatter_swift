//
//  MPColor.swift
//  MPFormatter
//
//  MIT Licensed, 2015, Tom Valk
//

import Foundation
import UIKit

class MPColor:MPStyles {
    
    private var color:UIColor
    
    init(color:UIColor, startIndex:Int){
        self.color = color
        
        super.init(start: startIndex)
    }
    
    func apply(inout attr:NSMutableAttributedString) {
        if(self.end != 0){
            attr.addAttribute(NSForegroundColorAttributeName, value: self.color, range: NSRange(location: self.start, length: self.end - self.start))
        }
    }
    
    class func isColor(input:String, startIndex:Int) -> MPColor? {
        if(countElements(input) == 3){
            return self.init(color: UIColor(rgbaSmall: input), startIndex: startIndex)
        }
        return nil
    }
}

extension UIColor {
    convenience init(rgbaSmall: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        if countElements(rgbaSmall) == 3 {
            let hex     = rgbaSmall
            let scanner = NSScanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexLongLong(&hexValue) {
                red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue  = CGFloat(hexValue & 0x00F)              / 15.0
            }
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}
