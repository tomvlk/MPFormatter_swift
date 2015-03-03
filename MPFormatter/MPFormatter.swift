//
//  MPFormatter.swift
//  MPFormatter
//
//  Created by Tom Valk on 03-03-15.
//  Copyright (c) 2015 Tom Valk. All rights reserved.
//

import Foundation
import UIKit

public enum MPFontStyle {
    case Italic, Bold, Shadow, Wide, Big, Small
}

public class MPFormatter {
    
    var colors:[MPColor] = []
    var styles:[MPStyle] = []
    var links:[MPLink] = []
    var ignore:[Int] = []
    
    public init() {
        
    }
    
    public func parseString(input:String, fontSize:Double) -> NSAttributedString {
        var output:String = ""
        
        for (idx, char) in enumerate(input) {
            if(idx == countElements(input)){
                // Stop all links, styles and colors
                self.stopAllColors(countElements(output))
                self.stopAllLinks(countElements(output))
                self.stopAllStyles(countElements(output))
            }
            if(char == "$" && countElements(input) > idx){
                let type = input.substringWithRange(Range<String.Index>(start: advance(input.startIndex, idx + 1), end: advance(input.startIndex, idx + 2)))
                
                // By default, always skip next char
                ignore.append(idx + 1)
                
                switch(type){
                    // Links
                case "l", "L", "m", "M":
                    self.stopAllLinks(countElements(output))
                    
                    // Get destination
                    if(countElements(input) > idx + 2){
                        let after = input.substringWithRange(Range<String.Index>(start: advance(input.startIndex, idx + 2), end: advance(input.startIndex, idx + 3)))
                        if(after == "[" && countElements(input) > idx + 3) {
                            // link invisible
                            // Get end position (])
                            if let endPoint: Range<String.Index> = input.rangeOfString("]", options: NSStringCompareOptions.allZeros, range: Range<String.Index>(start: advance(input.startIndex, idx + 3), end: input.endIndex), locale: nil) {
                                let url = input.substringWithRange(Range<String.Index>(start: advance(input.startIndex, idx + 3), end: endPoint.endIndex.predecessor()))
                                if let urlDest = NSURL(string: url) {
                                    let link = MPLink(destination: urlDest, startIndex: countElements(output))
                                    self.links.append(link)
                                }
                                
                                // Ignore all the url stuff [http://]
                                for skip in 0...countElements(url)+1 {
                                    ignore.append(idx + 2 + skip)
                                }
                            }
                            
                        }else{
                            // link visible, ignore $l and make it visible too
                        }
                    }else{
                        // Last one is link, maybe a stopper
                    }
                    //let link = MPLink(destination: "", startIndex: countElements(output))
                    break
                    
                    // Small
                case "n", "N":
                    self.stopAllStylesOfType(MPFontStyle.Big, endIndex: countElements(output))
                    self.stopAllStylesOfType(MPFontStyle.Wide, endIndex: countElements(output))
                    self.stopAllStylesOfType(MPFontStyle.Small, endIndex: countElements(output))
                    let styl = MPStyle(style: MPFontStyle.Small, startIndex: countElements(output), fontSize: CGFloat(fontSize))
                    self.styles.append(styl)
                    break
                    
                    // Italic
                case "i", "I":
                    self.stopAllStylesOfType(MPFontStyle.Italic, endIndex: countElements(output))
                    let styl = MPStyle(style: MPFontStyle.Italic, startIndex: countElements(output), fontSize: CGFloat(fontSize))
                    self.styles.append(styl)
                    break
                    
                    // Bold
                case "o", "O":
                    self.stopAllStylesOfType(MPFontStyle.Bold, endIndex: countElements(output))
                    let styl = MPStyle(style: MPFontStyle.Bold, startIndex: countElements(output), fontSize: CGFloat(fontSize))
                    self.styles.append(styl)
                    break
                    
                    // Shadow
                case "s", "S":
                    self.stopAllStylesOfType(MPFontStyle.Shadow, endIndex: countElements(output))
                    //let styl = MPStyle(style: MPFontStyle.Shadow, startIndex: countElements(output), fontSize: CGFloat(fontSize))
                    //self.styles.append(styl)
                    break
                    
                    // Wide
                case "w", "W":
                    self.stopAllStylesOfType(MPFontStyle.Wide, endIndex: countElements(output))
                    let styl = MPStyle(style: MPFontStyle.Wide, startIndex: countElements(output), fontSize: CGFloat(fontSize))
                    self.styles.append(styl)
                    break
                case "g", "G":
                    self.stopAllColors(countElements(output))
                    break
                case "z", "Z":
                    self.stopAllColors(countElements(output))
                    self.stopAllLinks(countElements(output))
                    self.stopAllStyles(countElements(output))
                    
                    break
                case "<", ">":
                    // ignore
                    break
                default:
                    self.stopAllColors(countElements(output))
                    
                    if(countElements(input) > idx+3){
                        let colorstring = input.substringWithRange(Range<String.Index>(start: advance(input.startIndex, idx + 1), end: advance(input.startIndex, idx + 4)))
                        if let color = MPColor.isColor(colorstring, startIndex: countElements(output)) {
                            colors.append(color)
                            ignore.append(idx + 2)
                            ignore.append(idx + 3)
                        }
                    }
                    break
                    
                }
                //println(type)
            }else{
                if let skip = find(ignore, idx) {
                    // Skip this char
                }else{
                    output.append(char)
                }
            }
        }
        
        var outputStyled = NSMutableAttributedString(string: output)
        
        // Apply default font first
        let defaultFont = UIFont.systemFontOfSize(CGFloat(fontSize))
        outputStyled.addAttribute(NSFontAttributeName, value: defaultFont, range: NSRange(location: 0, length: outputStyled.length))
        
        // Add all styles in attributed string
        
        // Colors
        for color in self.colors {
            if(color.end != 0){
                color.apply(&outputStyled)
            }
        }
        
        // Links
        for link in self.links {
            if(link.end != 0){
                link.apply(&outputStyled)
            }
        }
        
        // Styles
        for style in self.styles {
            if(style.end != 0){
                style.apply(&outputStyled)
            }
        }
        
        return outputStyled
    }
    
    private func stopAllLinks(endIndex:Int) {
        if let last = self.links.last {
            if(last.end == 0){
                last.end = endIndex
            }
        }
    }
    
    private func stopAllColors(endIndex:Int) {
        if let last = self.colors.last {
            if(last.end == 0){
                last.end = endIndex
            }
        }
    }
    
    private func stopAllStyles(endIndex:Int) {
        if let last = self.styles.last {
            if(last.end == 0){
                last.end = endIndex
            }
        }
    }
    
    private func stopAllStylesOfType(type:MPFontStyle, endIndex:Int) {
        if let last = self.styles.last {
            if(last.end == 0 && last.style == type){
                last.end = endIndex
            }
        }
    }
}
