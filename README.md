[![Build Status](https://travis-ci.org/tomvlk/MPFormatter_swift.png)](https://travis-ci.org/tomvlk/MPFormatter_swift)

# MPFormatter_swift
A ManiaPlanet Color Style parser and formatter for Swift

## Installation ##
To install the formatter you have two options:

##### Swift Package Dependency
Add the Github Clone URL as your dependency with XCode wizard to add Swift Package. Use package version 2 and higher.

## Usage ##
To use the framework:

To get the NSAttributedString from a styled nickname for example, use:
```swift
    let nickname = "$F80$i$S$oToffe$z$06FSmurf $z$n$l[http://goo.gl/y4M9VK][App]$l"
    let styledNickname = MPFormatter().parse(nickname).getAttributedString()
```
This will result in:
![Example result from above code](https://raw.githubusercontent.com/tomvlk/MPFormatter_swift/master/example.png "Example result")



You can also strip links, styles or colors with
```swift
	let nickname = "$F80$i$S$oToffe$z$06FSmurf $z$n$l[http://goo.gl/y4M9VK][App]$l"
    let noLinks = MPFormatter().parse(nickname).stripLinks().getAttributedString()
    let noColors = MPFormatter().parse(nickname).stripColors().getAttributedString()
    let plainString:String = MPFormatter().parse(nickname).getString() // Get plain string, without any styles

    // Get nickname with font size 11
    let tinyNickname = MPFormatter(fontSize: CGFloat(11)).parse(nickname).getAttributedString()
```
