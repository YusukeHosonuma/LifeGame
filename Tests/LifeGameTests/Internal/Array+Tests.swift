//
//  File.swift
//  
//
//  Created by Yusuke Hosonuma on 2020/07/16.
//

import XCTest
import SwiftCheck
@testable import LifeGame

final class ArrayExtensionTests: XCTestCase {
    func testGroup() {
        XCTAssertEqual(Array(0..<6).group(by: 1), [[0], [1], [2], [3], [4], [5]])
        XCTAssertEqual(Array(0..<6).group(by: 2), [[0, 1], [2, 3], [4, 5]])
        XCTAssertEqual(Array(0..<6).group(by: 3), [[0, 1, 2], [3, 4, 5]])
        XCTAssertEqual(Array(0..<6).group(by: 6), [[0, 1, 2, 3, 4, 5]])
        XCTAssertEqual(Array(0..<6).group(by: 7), [[0, 1, 2, 3, 4, 5]])

        XCTAssertEqual(Array(0..<7).group(by: 3), [[0, 1, 2], [3, 4, 5], [6]])
        XCTAssertEqual(Array(0..<8).group(by: 3), [[0, 1, 2], [3, 4, 5], [6, 7]])
        XCTAssertEqual(Array(0..<9).group(by: 3), [[0, 1, 2], [3, 4, 5], [6, 7, 8]])
    }
    
    func testRotated() {
        property("#") <- forAll { (xs: [Int], size: Int) in
            xs == xs.shifted(by: size).shifted(by: -size)
        }

        XCTAssertEqual([1, 2, 3].shifted(by: 0), [1, 2, 3])
        XCTAssertEqual([1, 2, 3].shifted(by: 1), [3, 1, 2])
        XCTAssertEqual([1, 2, 3].shifted(by: 2), [2, 3, 1])
        XCTAssertEqual([1, 2, 3].shifted(by: 3), [1, 2, 3])
        XCTAssertEqual([1, 2, 3].shifted(by: 4), [3, 1, 2])

        XCTAssertEqual([1, 2, 3].shifted(by: -1), [2, 3, 1])
        XCTAssertEqual([1, 2, 3].shifted(by: -2), [3, 1, 2])
        XCTAssertEqual([1, 2, 3].shifted(by: -3), [1, 2, 3])
        XCTAssertEqual([1, 2, 3].shifted(by: -1), [2, 3, 1])
    }
}
