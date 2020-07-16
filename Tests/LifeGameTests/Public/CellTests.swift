//
//  File.swift
//  
//
//  Created by Yusuke Hosonuma on 2020/07/17.
//

import XCTest
@testable import LifeGame

final class CellTests: XCTestCase {

    func testNext() {
        XCTContext.runActivity(named: "when Alive") { _ in
            let cell = Cell.alive
            XCTAssertEqual(cell.next(surroundingAliveCount: 0), .die)
            XCTAssertEqual(cell.next(surroundingAliveCount: 1), .die)
            XCTAssertEqual(cell.next(surroundingAliveCount: 2), .alive)
            XCTAssertEqual(cell.next(surroundingAliveCount: 3), .alive)
            XCTAssertEqual(cell.next(surroundingAliveCount: 4), .die)
            XCTAssertEqual(cell.next(surroundingAliveCount: 5), .die)
            XCTAssertEqual(cell.next(surroundingAliveCount: 6), .die)
            XCTAssertEqual(cell.next(surroundingAliveCount: 7), .die)
            XCTAssertEqual(cell.next(surroundingAliveCount: 8), .die)
        }
        
        XCTContext.runActivity(named: "when Die") { _ in
            let cell = Cell.die
            XCTAssertEqual(cell.next(surroundingAliveCount: 0), .die)
            XCTAssertEqual(cell.next(surroundingAliveCount: 1), .die)
            XCTAssertEqual(cell.next(surroundingAliveCount: 2), .die)
            XCTAssertEqual(cell.next(surroundingAliveCount: 3), .alive)
            XCTAssertEqual(cell.next(surroundingAliveCount: 4), .die)
            XCTAssertEqual(cell.next(surroundingAliveCount: 5), .die)
            XCTAssertEqual(cell.next(surroundingAliveCount: 6), .die)
            XCTAssertEqual(cell.next(surroundingAliveCount: 7), .die)
            XCTAssertEqual(cell.next(surroundingAliveCount: 8), .die)
        }
    }
}
