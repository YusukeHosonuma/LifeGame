//
//  Board+Arbitrary.swift
//  LifeGameTests
//
//  Created by Yusuke Hosonuma on 2020/08/08.
//

import LifeGame
import SwiftCheck

extension Board: Arbitrary where Cell == Int {
    public static var arbitrary: Gen<Board<Cell>> {
        Gen<Board<Int>>.compose { c in
            let size: UInt = max(1, c.generate())
            let cellCount = Int(size * size)
            let cells: [Int] = Array(repeating: false, count: cellCount).map { _ in
                let blank: Bool = c.generate()
                return blank ? 0 : 1
            }
            return Board(size: Int(size), cells: cells)
        }
    }
}
