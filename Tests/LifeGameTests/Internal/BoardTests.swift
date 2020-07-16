//
//  File.swift
//  
//
//  Created by Yusuke Hosonuma on 2020/07/16.
//

import XCTest
@testable import LifeGame

final class BoardTests: XCTestCase {
    let board = Board(size: 3, cells: [
        1, 2, 3,
        4, 5, 6,
        7, 8, 9,
    ])
    
    func testSurroundingCells() {
        XCTAssertEqual(Set(board.surroundingCells(index: 0)), [2, 4, 5])
        XCTAssertEqual(Set(board.surroundingCells(index: 1)), [1, 3, 4, 5, 6])
        XCTAssertEqual(Set(board.surroundingCells(index: 2)), [2, 5, 6])
        XCTAssertEqual(Set(board.surroundingCells(index: 3)), [1, 2, 5, 7, 8])
        XCTAssertEqual(Set(board.surroundingCells(index: 4)), [1, 2, 3, 4, 6, 7, 8, 9])
        XCTAssertEqual(Set(board.surroundingCells(index: 5)), [2, 3, 5, 8, 9])
        XCTAssertEqual(Set(board.surroundingCells(index: 6)), [4, 5, 8])
        XCTAssertEqual(Set(board.surroundingCells(index: 7)), [4, 5, 6, 7, 9])
        XCTAssertEqual(Set(board.surroundingCells(index: 8)), [5, 6, 8])
    }
}
