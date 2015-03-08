//
//  MPFormatter.swift
//  MPFormatter
//
//  MIT Licensed, 2015, Tom Valk
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
    
    var fontSize:CGFloat = UIFont.systemFontSize()
    
    public init() {
        
    }
    
    public init(fontSize: CGFloat) {
        self.fontSize = fontSize
    }
    
    public class MPFormattedString {
        
        private var formatter:MPFormatter
        private var output:String
        
        private var parseColors = true
        private var parseLinks = true
        private var parseStyles = true
        
        init(fromFormatter: MPFormatter, outputString:String) {
            self.formatter = fromFormatter
            self.output = outputString
        }
        
        /// Strip all the links
        public func stripLinks() {
            self.parseLinks = false
        }
        
        /// Strip all the styles, links and colors
        /// You can also use getString() to only get the plain text string back
        public func stripAll() {
            self.parseColors = false
            self.parseLinks = false
            self.parseStyles = false
        }
        
        /// Strip all styles
        public func stripStyles() {
            self.parseStyles = false
        }
        
        /// Strip all colors
        public func stripColors() {
            self.parseColors = false
        }
        
        /// Get Attributed String back
        /// :returns: Attributed String
        public func getAttributedString() -> NSAttributedString {
            return self.parseFormatted(self.output)
        }
        
        /// Get Plain String back
        /// :returns: Stripped string
        public func getString() -> String {
            return self.output
        }
        
        private func parseFormatted(output:String) -> NSAttributedString {
            // Make the mutable attributed string
            var outputStyled = NSMutableAttributedString(string: self.output)
            
            // Apply default font
            let defaultFont = UIFont.systemFontOfSize(formatter.fontSize)
            outputStyled.addAttribute(NSFontAttributeName, value: defaultFont, range: NSRange(location: 0, length: outputStyled.length))
            
            // Apply colors
            if(self.parseColors) {
                // Colors
                for color in self.formatter.colors {
                    if(color.end != 0){
                        color.apply(&outputStyled)
                    }
                }
            }
            
            // Apply styles
            if(self.parseStyles) {
                // Styles
                for style in self.formatter.styles {
                    if(style.end != 0){
                        style.apply(&outputStyled)
                    }
                }
            }
            
            // Apply links
            if(self.parseLinks) {
                // Links
                for link in self.formatter.links {
                    if(link.end != 0){
                        link.apply(&outputStyled)
                    }
                }
            }
            
            return outputStyled
        }
    }
    
    /// Parse the input string
    /// 
    /// :param: input The input string with $ styles
    ///
    /// :returns: MPFormattedString
    public func parse(#input:String) -> MPFormattedString {
        var output:String = ""
        
        // Parse the styles in the input string
        for (idx, char) in enumerate(input) {
            if(char == "$" && countElements(input) > idx){
                let type = input.substringWithRange(Range<String.Index>(start: advance(input.startIndex, idx + 1), end: advance(input.startIndex, idx + 2)))
                
                // By default, always skip next char
                ignore.append(idx + 1)
                
                // Decide the type of styling
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
            }else{
                if let skip = find(ignore, idx) {
                    // Skip this char
                }else{
                    output.append(char)
                }
            }
            
            // Stop all attributes if we are on the end of the string
            if(idx+1 == countElements(input) && countElements(input) != 0){
                self.stopAllColors(countElements(output))
                self.stopAllLinks(countElements(output))
                self.stopAllStyles(countElements(output))
            }
        }
        
        // Make the formattedstring class, return it
        return MPFormattedString(fromFormatter: self, outputString: output)
    }
    
    private func stopAllLinks(endIndex:Int) {
        for item in self.links {
            if(item.end == 0){
                item.end = endIndex
            }
        }
    }
    
    private func stopAllColors(endIndex:Int) {
        for item in self.colors {
            if(item.end == 0){
                item.end = endIndex
            }
        }
    }
    
    private func stopAllStyles(endIndex:Int) {
        for item in self.styles {
            if(item.end == 0){
                item.end = endIndex
            }
        }
    }
    
    private func stopAllStylesOfType(type:MPFontStyle, endIndex:Int) {
        for item in self.styles {
            if(item.end == 0 && item.style == type){
                item.end = endIndex
            }
        }
    }
}
