//
//  MPStyle.swift
//  MPFormatter
//
//  MIT Licensed, 2015, Tom Valk
//

import Foundation
import UIKit

class MPStyle:MPStyles {
    
    private var font:UIFont = UIFont()
    var style:MPFontStyle
    
    init(style:MPFontStyle, startIndex:Int, fontSize:CGFloat) {
        self.style = style
        
        switch(self.style){
        case .Bold:
            self.font = UIFont.boldSystemFontOfSize(fontSize)
            break
        case .Big:
            self.font = UIFont.systemFontOfSize(fontSize + CGFloat(4))
            break
        case .Italic:
            self.font = UIFont.italicSystemFontOfSize(fontSize)
            break
        case .Small:
            self.font = UIFont.systemFontOfSize(fontSize - CGFloat(4))
            break
        case .Wide:
            self.font = UIFont.systemFontOfSize(fontSize + CGFloat(6))
            break
        case .Shadow:
            break
        }
        
        super.init(start: startIndex)
    }
    
    func apply(inout attr:NSMutableAttributedString) {
        if(self.end != 0){
            if(self.style == .Bold){
                attr.addAttribute(NSFontAttributeName, value: self.font, range: NSRange(location: self.start, length: self.end - self.start))
            }
        }
    }
}

