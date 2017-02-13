//
//  MPFormatter.swift
//  MPFormatter
//
//  MIT Licensed, 2015, Tom Valk
//

import Foundation
import UIKit

public enum MPFontStyle {
    case italic, bold, shadow, wide, big, small
}

public class MPFormatter {
    
    var colors:[MPColor] = []
    var styles:[MPStyle] = []
    var links:[MPLink] = []
    var ignore:[Int] = []
    
    var fontSize:CGFloat = 12
    
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
        public func stripLinks() -> MPFormattedString {
            self.parseLinks = false
            return self
        }
        
        /// Strip all the styles, links and colors
        /// You can also use getString() to only get the plain text string back
        public func stripAll() -> MPFormattedString {
            self.parseColors = false
            self.parseLinks = false
            self.parseStyles = false
            return self
        }
        
        /// Strip all styles
        public func stripStyles() -> MPFormattedString {
            self.parseStyles = false
            return self
        }
        
        /// Strip all colors
        public func stripColors() -> MPFormattedString {
            self.parseColors = false
            return self
        }
        
        /// Get Attributed String back
        /// - returns: Attributed String
        public func getAttributedString() -> AttributedString {
            return self.parseFormatted(self.output)
        }
        
        /// Get Plain String back
        /// - returns: Stripped string
        public func getString() -> String {
            return self.output
        }
        
        private func parseFormatted(_ output:String) -> AttributedString {
            // Make the mutable attributed string
            var outputStyled = NSMutableAttributedString(string: self.output)
            
            // Apply default font
            let defaultFont = UIFont.systemFont(ofSize: formatter.fontSize)
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
    /// - parameter input: The input string with $ styles
    ///
    /// - returns: MPFormattedString
    public func parse(_ input:String) -> MPFormattedString {
        var output:String = ""
        
        // Parse the styles in the input string
        for (idx, char) in input.characters.enumerated() {
            if(char == "$" && input.characters.count > idx+1){
                let type = input.substring(with: (input.characters.index(input.startIndex, offsetBy: idx + 1) ..< input.characters.index(input.startIndex, offsetBy: idx + 2)))
                
                // By default, always skip next char
                ignore.append(idx + 1)
                
                // Decide the type of styling
                switch(type){
                    // Links
                case "l", "L", "m", "M", "h", "H":
                    self.stopAllLinks(output.characters.count)
                    
                    // Get destination
                    if(input.characters.count > idx + 2){
                        let after = input.substring(with: (input.characters.index(input.startIndex, offsetBy: idx + 2) ..< input.characters.index(input.startIndex, offsetBy: idx + 3)))
                        if(after == "[" && input.characters.count > idx + 3) {
                            // link invisible
                            // Get end position (])
                            if let endPoint: Range<String.Index> = input.range(of: "]", options: NSString.CompareOptions(), range: (input.characters.index(input.startIndex, offsetBy: idx + 3) ..< input.endIndex), locale: nil) {
                                let url = input.substring(with: (input.characters.index(input.startIndex, offsetBy: idx + 3) ..< endPoint.lowerBound)) // .index(before: endPoint.endIndex)
                                if let urlDest = URL(string: url) {
                                    let link = MPLink(destination: urlDest, startIndex: output.characters.count)
                                    self.links.append(link)
                                }
                                
                                // Ignore all the url stuff [http://]
                                for skip in 0...url.characters.count+1 {
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
                    self.stopAllStylesOfType(MPFontStyle.big, endIndex: output.characters.count)
                    self.stopAllStylesOfType(MPFontStyle.wide, endIndex: output.characters.count)
                    self.stopAllStylesOfType(MPFontStyle.small, endIndex: output.characters.count)
                    let styl = MPStyle(style: MPFontStyle.small, startIndex: output.characters.count, fontSize: CGFloat(fontSize))
                    self.styles.append(styl)
                    break
                    
                    // Italic
                case "i", "I":
                    self.stopAllStylesOfType(MPFontStyle.italic, endIndex: output.characters.count)
                    let styl = MPStyle(style: MPFontStyle.italic, startIndex: output.characters.count, fontSize: CGFloat(fontSize))
                    self.styles.append(styl)
                    break
                    
                    // Bold
                case "o", "O":
                    self.stopAllStylesOfType(MPFontStyle.bold, endIndex: output.characters.count)
                    let styl = MPStyle(style: MPFontStyle.bold, startIndex: output.characters.count, fontSize: CGFloat(fontSize))
                    self.styles.append(styl)
                    break
                    
                    // Shadow
                case "s", "S":
                    self.stopAllStylesOfType(MPFontStyle.shadow, endIndex: output.characters.count)
                    //let styl = MPStyle(style: MPFontStyle.Shadow, startIndex: countElements(output), fontSize: CGFloat(fontSize))
                    //self.styles.append(styl)
                    break
                    
                    // Wide
                case "w", "W":
                    self.stopAllStylesOfType(MPFontStyle.wide, endIndex: output.characters.count)
                    let styl = MPStyle(style: MPFontStyle.wide, startIndex: output.characters.count, fontSize: CGFloat(fontSize))
                    self.styles.append(styl)
                    break
                case "g", "G":
                    self.stopAllColors(output.characters.count)
                    break
                case "z", "Z":
                    self.stopAllColors(output.characters.count)
                    self.stopAllLinks(output.characters.count)
                    self.stopAllStyles(output.characters.count)
                    
                    break
                case "<", ">":
                    // ignore
                    break
                default:
                    self.stopAllColors(output.characters.count)
                    
                    if(input.characters.count > idx+3){
                        let colorstring = input.substring(with: (input.characters.index(input.startIndex, offsetBy: idx + 1) ..< input.characters.index(input.startIndex, offsetBy: idx + 4)))
                        if let color = MPColor.isColor(colorstring, startIndex: output.characters.count) {
                            colors.append(color)
                            ignore.append(idx + 2)
                            ignore.append(idx + 3)
                        }
                    }
                    break
                    
                }
            }else{
                if let _ = ignore.index(of: idx) {
                    // Skip this char
                }else{
                    output.append(char)
                }
            }
            
            // Stop all attributes if we are on the end of the string
            if(idx+1 == input.characters.count && input.characters.count != 0){
                self.stopAllColors(output.characters.count)
                self.stopAllLinks(output.characters.count)
                self.stopAllStyles(output.characters.count)
            }
        }
        
        // Make the formattedstring class, return it
        return MPFormattedString(fromFormatter: self, outputString: output)
    }
    
    private func stopAllLinks(_ endIndex:Int) {
        for item in self.links {
            if(item.end == 0){
                item.end = endIndex
            }
        }
    }
    
    private func stopAllColors(_ endIndex:Int) {
        for item in self.colors {
            if(item.end == 0){
                item.end = endIndex
            }
        }
    }
    
    private func stopAllStyles(_ endIndex:Int) {
        for item in self.styles {
            if(item.end == 0){
                item.end = endIndex
            }
        }
    }
    
    private func stopAllStylesOfType(_ type:MPFontStyle, endIndex:Int) {
        for item in self.styles {
            if(item.end == 0 && item.style == type){
                item.end = endIndex
            }
        }
    }
}
