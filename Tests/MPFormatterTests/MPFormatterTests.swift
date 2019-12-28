import XCTest
@testable import MPFormatter

final class MPFormatterTests: XCTestCase {
    func testSimple() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(MPFormatter().parse("Hello, World!").getString(), "Hello, World!")
    }
    
    func testStripping() {
        let input = "$06fMyColor$[link]Link$l$oTest$wBold$sShadow$zNormal"
        let formatter = MPFormatter()
        let formattedString = formatter.parse(input)
        let attributedString: NSAttributedString = formattedString.getAttributedString()
        
        let attributes = attributedString.attributes(at: 0, effectiveRange: nil)
        XCTAssertEqual(attributes.count, 2)
        
        let strippedAttributedString: NSAttributedString = formattedString.stripAll().getAttributedString()
        let strippedAttributes = strippedAttributedString.attributes(at: 0, effectiveRange: nil)
        XCTAssertEqual(strippedAttributes.count, 1)
    }

    static var allTests = [
        ("testSimple", testSimple),
        ("testStripping", testStripping)
    ]
}
