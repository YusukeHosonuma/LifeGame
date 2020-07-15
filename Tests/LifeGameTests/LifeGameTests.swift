import XCTest
@testable import LifeGame

final class LifeGameTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(LifeGame().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
