//
//  File.swift
//  
//
//  Created by Yusuke Hosonuma on 2020/07/16.
//

import XCTest
import SwiftCheck
@testable import LifeGame

final class BoardTests: XCTestCase {
    let board = Board(size: 3, cells: [
        1, 2, 3,
        4, 5, 6,
        7, 8, 9,
    ])
    
    func testInit() {
        let board = Board(size: 2, cell: 0)
        XCTAssertEqual(board.size, 2)
        XCTAssertEqual(board.cells, [
            0, 0,
            0, 0,
        ])
    }
    
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
    
    func testSetBoardToCenter() {
        let isBlank: (Int) -> Bool = { $0 == 0 }
        
        property("対面する辺のブランクサイズの差は0または1になる") <- forAll { (baseSize: UInt, setSize: UInt) in
            return (baseSize > 0 && setSize > 0 && baseSize >= setSize) ==> {
                let board = Board(size: Int(baseSize), cell: 0)
                    .setBoard(toCenter: Board(size: Int(setSize), cell: 1))
                
                let diffY = abs(board.topLineCount(by: isBlank) - board.bottomLineCount(by: isBlank))
                let diffX = abs(board.leftLineCount(by: isBlank) - board.rightLineCount(by: isBlank))
                
                return
                    (board.size == baseSize) <?> "盤面のサイズは変わらない"
                    ^&&^
                    ((diffX == 0 || diffX == 1) && (diffY == 0 || diffY == 1)) <?> "対面する辺のブランクサイズの差は0または1"
            }
        }
        
        XCTAssertEqual(
            Board(size: 4, cell: 0).setBoard(toCenter: Board(size: 2, cell: 1)),
            Board(size: 4, cells: [
                0, 0, 0, 0,
                0, 1, 1, 0,
                0, 1, 1, 0,
                0, 0, 0, 0,
            ])
        )
        
        XCTAssertEqual(
            Board(size: 3, cell: 0).setBoard(toCenter: Board(size: 2, cell: 1)),
            Board(size: 3, cells: [
                1, 1, 0,
                1, 1, 0,
                0, 0, 0,
            ])
        )
    }
    
    func testExtended() {
        do {
            let board = Board(size: 1, cells: [
                1
            ]).extended(by: 0)
            
            XCTAssertEqual(board.size, 3)
            XCTAssertEqual(board.cells, [
                0, 0, 0,
                0, 1, 0,
                0, 0, 0,
            ])
        }

        do {
            let board = Board(size: 2, cells: [
                1, 1,
                1, 1,
            ]).extended(by: 0)
            
            XCTAssertEqual(board.size, 4)
            XCTAssertEqual(board.cells, [
                0, 0, 0, 0,
                0, 1, 1, 0,
                0, 1, 1, 0,
                0, 0, 0, 0,
            ])
        }
    }
    
    func testTrimed() {
        let isBlank: (Int) -> Bool = { $0 == 0 }
        let isNotBlank: (Int) -> Bool = { $0 == 1 }
        
        property("トリムを2回行っても結果は変わらない") <- forAll { (board: Board<Int>) in
            board.trimed(by: isBlank) == board.trimed(by: isBlank).trimed(by: isBlank)
        }
        
        property("トリムされてもブランクでないセルの数は変化しない") <- forAll { (board: Board<Int>) in
            board.cells.filter(isNotBlank).count == board.trimed(by: isBlank).cells.filter(isNotBlank).count
        }
        
        XCTAssertEqual(
            Board(size: 1, cells: [1]).trimed(by: isBlank),
            Board(size: 1, cells: [1]),
            "Board is not changed when 1x1."
        )
        
        XCTAssertEqual(
            Board(size: 2, cells: [
                0, 0,
                0, 0,
            ]).trimed(by: isBlank),
            Board(size: 1, cells: [0]),
            "Return board that size is 1x1 when all cells are blank."
        )
        
        XCTAssertEqual(
            Board(size: 3, cells: [
                0, 1, 0,
                0, 0, 0,
                0, 0, 0,
            ]).trimed(by: isBlank),
            Board(size: 1, cells: [1]),
            "Blank cells are trimed."
        )
    }
}
