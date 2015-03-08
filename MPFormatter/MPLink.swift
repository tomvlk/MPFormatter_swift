//
//  MPLink.swift
//  MPFormatter
//
//  MIT Licensed, 2015, Tom Valk
//

import Foundation
import UIKit

class MPLink:MPStyles {
    
    private var destination:NSURL
    
    init(destination:NSURL, startIndex:Int) {
        self.destination = destination
        
        super.init(start: startIndex)
    }
    
    func apply(inout attr:NSMutableAttributedString) {
        if(self.end != 0){
            attr.addAttribute(NSLinkAttributeName, value: self.destination, range: NSRange(location: self.start, length: self.end - self.start))
        }
    }
}
