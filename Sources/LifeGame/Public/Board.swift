//
//  File.swift
//  
//
//  Created by Yusuke Hosonuma on 2020/07/16.
//

import Foundation

public struct Board<Cell> {
    private (set) var size: Int
    private (set) var cells: [Cell]

    init(size: Int, cells: [Cell]) {
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
    
    public mutating func trim(by isBlank: (Cell) -> Bool) {
        
        func topBlank(_ cells: [Cell]) -> Int {
            cells
                .group(by: size)
                .prefix(while: { $0.allSatisfy(isBlank) })
                .count
        }
        
        func bottomBlank(_ cells: [Cell]) -> Int {
            cells
                .group(by: size)
                .reversed()
                .prefix(while: { $0.allSatisfy(isBlank) })
                .count
        }
        
        func leftBlank(_ cells: [Cell]) -> Int {
            cells
                .group(by: size)
                .map { $0.prefix(while: isBlank).count }
                .min() ?? 0
        }
        
        func rightBlank(_ cells: [Cell]) -> Int {
            cells
                .group(by: size)
                .map { $0.reversed().prefix(while: isBlank).count }
                .min() ?? 0
        }
        
        let trimTopLeft = min(topBlank(cells), leftBlank(cells))
        let trimBottomRight = min(bottomBlank(cells), rightBlank(cells))
        
        let trimedCells = Array(
            cells.group(by: size)
                .map { $0.dropFirst(trimTopLeft).dropLast(trimBottomRight) }
                .dropFirst(trimTopLeft)
                .dropLast(trimBottomRight)
                .joined()
        )

        let trimBottomLeft = min(bottomBlank(trimedCells), leftBlank(trimedCells))
        let trimTopRight = min(topBlank(trimedCells), rightBlank(trimedCells))

        cells = Array(
            trimedCells
                .group(by: size)
                .map { $0.dropFirst(trimBottomLeft).dropLast(trimTopRight) }
                .dropFirst(trimTopRight)
                .dropLast(trimBottomLeft)
                .joined()
        )
        size = size - (trimTopLeft + trimBottomRight + trimBottomLeft + trimTopRight)
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
