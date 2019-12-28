//
//  MPLink.swift
//  MPFormatter
//
//  MIT Licensed, 2017, Tom Valk
//

import Foundation
import UIKit

class MPLink:MPStyles {
    
    fileprivate var destination:URL
    
    init(destination:URL, startIndex:Int) {
        self.destination = destination
        
        super.init(start: startIndex)
    }
    
    func apply(_ attr:inout NSMutableAttributedString) {
        if(self.end != 0){
            attr.addAttribute(NSAttributedString.Key.link, value: self.destination, range: NSRange(location: self.start, length: self.end - self.start))
        }
    }
}
