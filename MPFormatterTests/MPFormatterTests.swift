//
//  MPFormatterTests.swift
//  MPFormatterTests
//
//  Copyright (c) 2015 Tom Valk. All rights reserved.
//

import UIKit
import XCTest

import MPFormatter

class MPFormatterTests: XCTestCase {
    
    func testFormattingString() {
        let compiled = "$o$w$f0fTe$h[test]st$h$l[test]ing"
        let needstobe = "Testing"
        
        XCTAssertEqual(MPFormatter().parse(input: compiled).getString(), needstobe, "The compiled string parsed down to a plain string needs to be the exact same as it is without styles")
    }
    
    func testFormattingSameDifferentOrder() {
        let compiled1 = "$lhttp://google.com$lTesting"
        let compiled2 = "$l[http://google.com]http://google.com$lTesting"
        
        XCTAssertEqual(MPFormatter().parse(input: compiled1).getString(), MPFormatter().parse(input: compiled2).getString(), "Needs to be the same, different $l link styles")
    }
    
}
