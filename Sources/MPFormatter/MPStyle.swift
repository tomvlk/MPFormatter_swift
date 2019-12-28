//
//  MPStyle.swift
//  MPFormatter
//
//  MIT Licensed, 2017, Tom Valk
//

import Foundation
import UIKit

class MPStyle:MPStyles {
    
    fileprivate var font:UIFont = UIFont()
    var style:MPFontStyle
    
    init(style:MPFontStyle, startIndex:Int, fontSize:CGFloat) {
        self.style = style
        
        switch(self.style){
        case .bold:
            self.font = UIFont.boldSystemFont(ofSize: fontSize)
            break
        case .big:
            self.font = UIFont.systemFont(ofSize: fontSize + CGFloat(4))
            break
        case .italic:
            self.font = UIFont.italicSystemFont(ofSize: fontSize)
            break
        case .small:
            self.font = UIFont.systemFont(ofSize: fontSize - CGFloat(4))
            break
        case .wide:
            self.font = UIFont.systemFont(ofSize: fontSize + CGFloat(6))
            break
        case .shadow:
            break
        }
        
        super.init(start: startIndex)
    }
    
    func apply(_ attr:inout NSMutableAttributedString) {
        if(self.end != 0){
            if(self.style == .bold){
                attr.addAttribute(NSAttributedString.Key.font, value: self.font, range: NSRange(location: self.start, length: self.end - self.start))
            }
        }
    }
}
