# MPFormatter_swift
A ManiaPlanet Color Style parser and formatter for Swift

## Usage ##
To use the framework you have to link the framework with the target of your app.

 1. Copy the files to a directory in your project folder
 2. Drag and drop the xcodeproj file to the project navigator, just under your app project
 3. Go to your App target
 4. Click on the + in the general tab under embedded binaries
 5. Select MPFormatter and click OK
 6. Now you can use MPFormatter with import MPFormatter

To get the NSAttributedString from a styled nickname for example, use:

    let nickname = "$F80$i$S$oToffe$z$06FSmurf $z$n$l[http://goo.gl/y4M9VK][App]$l"
    let styledNickname = MPFormatter().parse(input: nickname).getAttributedString()

This will result in:
![Example result from above code](https://raw.githubusercontent.com/tomvlk/MPFormatter_swift/master/example.png "Example result")



You can also strip links, styles or colors with

	let nickname = "$F80$i$S$oToffe$z$06FSmurf $z$n$l[http://goo.gl/y4M9VK][App]$l"
    let noLinks = MPFormatter().parse(input: nickname).stripLinks().getAttributedString()
    let noColors = MPFormatter().parse(input: nickname).stripColors().getAttributedString()
    let plainString:String = MPFormatter().parse(input: nickname).getString() // Get plain string, without any styles

    // Get nickname with font size 11
    let tinyNickname = MPFormatter(fontSize: CGFloat(11)).parse(input: nickname).getAttributedString()


