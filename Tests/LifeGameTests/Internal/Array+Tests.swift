//
//  File.swift
//  
//
//  Created by Yusuke Hosonuma on 2020/07/16.
//

import XCTest
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
}
