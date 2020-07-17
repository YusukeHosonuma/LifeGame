//
//  File.swift
//  
//
//  Created by Yusuke Hosonuma on 2020/07/15.
//

import XCTest
@testable import LifeGame

final class LifeGameBoardTests: XCTestCase {

    func testNext() {
        // life = 0
        assertBoard([
            0, 0, 0,
            0, 1, 0,
            0, 0, 0,
        ], [
            0, 0, 0,
            0, 0, 0,
            0, 0, 0,
        ])

        // life = 1
        assertBoard([
            0, 1, 0,
            0, 1, 0,
            0, 0, 0,
        ], [
            0, 0, 0,
            0, 0, 0,
            0, 0, 0,
        ])

        // life = 2
        assertBoard([
            0, 1, 1,
            0, 1, 0,
            0, 0, 0,
        ], [
            0, 1, 1,
            0, 1, 1,
            0, 0, 0,
        ])
        
        // life = 3
        assertBoard([
            0, 1, 1,
            0, 1, 1,
            0, 0, 0,
        ], [
            0, 1, 1,
            0, 1, 1,
            0, 0, 0,
        ])
        
        // life = 4
        assertBoard([
            0, 1, 1,
            0, 1, 1,
            0, 0, 1,
        ], [
            0, 1, 1,
            0, 0, 0,
            0, 1, 1,
        ])
        
        // life = 5
        assertBoard([
            0, 1, 1,
            0, 1, 1,
            0, 1, 1,
        ], [
            0, 1, 1,
            1, 0, 0,
            0, 1, 1,
        ])
        
        // life = 6
        assertBoard([
            0, 1, 1,
            0, 1, 1,
            1, 1, 1,
        ], [
            0, 1, 1,
            0, 0, 0,
            1, 0, 1,
        ])

        // life = 7
        assertBoard([
            0, 1, 1,
            1, 1, 1,
            1, 1, 1,
        ], [
            1, 0, 1,
            0, 0, 0,
            1, 0, 1,
        ])
        
        // life = 8
        assertBoard([
            1, 1, 1,
            1, 1, 1,
            1, 1, 1,
        ], [
            1, 0, 1,
            0, 0, 0,
            1, 0, 1,
        ])
    }
    
    func testClear() {
        var board = LifeGameBoard(size: 3, cells: [
            0, 0, 0,
            0, 1, 0,
            0, 0, 0,
        ])
        
        board.clear()
        
        XCTAssert(board.cells.count == 9)
        XCTAssert(board.cells.allSatisfy { $0 == .die })
    }
    
    func assertBoard(_ before: [Int], _ after: [Int]) {
        var board = LifeGameBoard(size: 3, cells: before)
        board.next()
        
        let actual = board.cells.map(\.rawValue)
        
        func format(_ cells: [Int]) -> String {
            cells.map { $0 == 1 ? "■" : "□" }.group(by: 3).map { $0.joined() }.joined(separator: "\n")
        }
        
        XCTAssertEqual(actual, after, "\n\n" + """
        input:
        \(format(before))

        expedted:
        \(format(after))

        actual:
        \(format(actual))
        """)
    }
}
