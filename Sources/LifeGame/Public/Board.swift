//
//  File.swift
//  
//
//  Created by Yusuke Hosonuma on 2020/07/16.
//

import Foundation

extension Board: Equatable where Cell: Equatable {
    public static func == (lhs: Board<Cell>, rhs: Board<Cell>) -> Bool {
        lhs.size == rhs.size && lhs.cells == rhs.cells
    }
}

public struct Board<Cell> {
    public private(set) var size: Int
    public private(set) var cells: [Cell]

    public init(size: Int, cells: [Cell]) {
        precondition(size * size == cells.count)
        
        self.size = size
        self.cells = cells
    }
    
    subscript(_ index: Int) -> Cell {
        get {
            cells[index]
        }
        set(cell) {
            cells[index] = cell
        }
    }
    
    public mutating func apply(_ board: Board) {
        precondition(board.size <= size)
        
        for (y, row) in board.rows.enumerated() {
            for (x, cell) in row.enumerated() {
                let index = y * self.size + x
                self.cells[index] = cell
            }
        }
    }

    // TODO: とりあえず +1 のみサポート
    public func extended(by cell: Cell) -> Board<Cell> {
        let head = [Array(repeating: cell, count: size + 2)]
        let last = [Array(repeating: cell, count: size + 2)]
        let body = cells.group(by: size).map { [cell] + $0 + [cell] }
        return Board(size: size + 2, cells: Array((head + body + last).joined()))
    }
    
    public func trimed(by isBlank: (Cell) -> Bool) -> Board<Cell> {
        // 1x1 のときは何もせずに自身を返す
        guard size > 1 else { return self }
        
        // すべてブランクの場合、1x1のブランクな盤面を返す
        guard cells.filter(isBlank).count < cells.count else {
            return Board(size: 1, cells: [cells.first!])
        }
        
        func topBlank(_ cells: [Cell], _ size: Int) -> Int {
            cells
                .group(by: size)
                .prefix(while: { $0.allSatisfy(isBlank) })
                .count
        }
        
        func bottomBlank(_ cells: [Cell], _ size: Int) -> Int {
            cells
                .group(by: size)
                .reversed()
                .prefix(while: { $0.allSatisfy(isBlank) })
                .count
        }
        
        func leftBlank(_ cells: [Cell], _ size: Int) -> Int {
            cells
                .group(by: size)
                .map { $0.prefix(while: isBlank).count }
                .min() ?? 0
        }
        
        func rightBlank(_ cells: [Cell], _ size: Int) -> Int {
            cells
                .group(by: size)
                .map { $0.reversed().prefix(while: isBlank).count }
                .min() ?? 0
        }
        
        let trimTopLeft = min(topBlank(cells, size), leftBlank(cells, size))
        let trimBottomRight = min(bottomBlank(cells, size), rightBlank(cells, size))
        let trimedSize = size - (trimTopLeft + trimBottomRight)
        
        let trimedCells = Array(
            cells.group(by: size)
                .map { $0.dropFirst(trimTopLeft).dropLast(trimBottomRight) }
                .dropFirst(trimTopLeft)
                .dropLast(trimBottomRight)
                .joined()
        )

        let trimBottomLeft = min(bottomBlank(trimedCells, trimedSize), leftBlank(trimedCells, trimedSize))
        let trimTopRight = min(topBlank(trimedCells, trimedSize), rightBlank(trimedCells, trimedSize))

        return Board(size: trimedSize - (trimBottomLeft + trimTopRight),
                     cells: Array(
                        trimedCells
                            .group(by: trimedSize)
                            .map { $0.dropFirst(trimBottomLeft).dropLast(trimTopRight) }
                            .dropFirst(trimTopRight)
                            .dropLast(trimBottomLeft)
                            .joined()
                    ))
    }
    
    func surroundingCells(index: Int) -> [Cell] {
        let isLeftEdge = index % size == 0
        let isRightEdge = (index + 1) % size == 0
        
        let up        = index - size
        let upLeft    = isLeftEdge  ? -1 : up - 1
        let upRight   = isRightEdge ? -1 : up + 1
        let left      = isLeftEdge  ? -1 : index - 1
        let right     = isRightEdge ? -1 : index + 1
        let down      = index + size
        let downLeft  = isLeftEdge  ? -1 : down - 1
        let downRight = isRightEdge ? -1 : down + 1
        
        return [up, upLeft, upRight, left, right, downLeft, down, downRight].compactMap { index in
            if 0 <= index && index < cells.count {
                return cells[index]
            } else {
                return nil
            }
        }
    }
    
    // MARK: - Private
    
    private var rows: [[Cell]] {
        cells.group(by: size)
    }
}
