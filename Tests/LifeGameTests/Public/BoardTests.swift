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
    
    func testApply() {
        XCTContext.runActivity(named: "Size is smaller than target") { _ in
            var board = Board(size: 3, cells: [
                0, 0, 0,
                0, 0, 0,
                0, 0, 0,
            ])
            
            board.apply(Board(size: 2, cells: [
                1, 2,
                3, 4
            ]))
            
            XCTAssertEqual(board.cells, [
                1, 2, 0,
                3, 4, 0,
                0, 0, 0,
            ])
        }
        
        XCTContext.runActivity(named: "Size is same to target") { _ in
            var board = Board(size: 3, cells: [
                0, 0, 0,
                0, 0, 0,
                0, 0, 0,
            ])
            
            board.apply(Board(size: 3, cells: [
                1, 2, 3,
                4, 5, 6,
                7, 8, 9,
            ]))
            
            XCTAssertEqual(board.cells, [
                1, 2, 3,
                4, 5, 6,
                7, 8, 9,
            ])
        }
    }
    
    func testCrop() {
        do {
            let board = Board(size: 5, cells: [
                0, 0, 0, 0, 0,
                0, 0, 0, 0, 0,
                0, 0, 1, 0, 0,
                0, 0, 0, 0, 0,
                0, 0, 0, 0, 0,
            ]).trimed { $0 == 0 }

            XCTAssertEqual(board.size, 1)
            XCTAssertEqual(board.cells, [
                1
            ])
        }
        
        do {
            let board = Board(size: 3, cells: [
                0, 0, 0,
                0, 1, 0,
                0, 0, 0,
            ]).trimed { $0 == 0 }

            XCTAssertEqual(board.size, 1)
            XCTAssertEqual(board.cells, [
                1
            ])
        }
        
        
        do {
            let board = Board(size: 1, cells: [
                1,
            ]).trimed { $0 == 0 }

            XCTAssertEqual(board.size, 1)
            XCTAssertEqual(board.cells, [
                1
            ])
        }

        do {
            let board = Board(size: 3, cells: [
                1, 0, 0,
                1, 0, 0,
                0, 0, 0,
            ]).trimed { $0 == 0 }

            XCTAssertEqual(board.size, 2)
            XCTAssertEqual(board.cells, [
                1, 0,
                1, 0,
            ])
        }
        
        
        do {
            let board = Board(size: 3, cells: [
                0, 0, 0,
                1, 0, 0,
                1, 0, 0,
            ]).trimed { $0 == 0 }

            XCTAssertEqual(board.size, 2)
            XCTAssertEqual(board.cells, [
                1, 0,
                1, 0,
            ])
        }
        
        do {
            let board = Board(size: 3, cells: [
                0, 0, 1,
                0, 0, 1,
                0, 0, 0,
            ]).trimed { $0 == 0 }

            XCTAssertEqual(board.size, 2)
            XCTAssertEqual(board.cells, [
                0, 1,
                0, 1,
            ])
        }
        
        do {
            let board = Board(size: 3, cells: [
                0, 0, 0,
                0, 0, 1,
                0, 0, 1,
            ]).trimed { $0 == 0 }

            XCTAssertEqual(board.size, 2)
            XCTAssertEqual(board.cells, [
                0, 1,
                0, 1,
            ])
        }

    }
}
