//
//  File.swift
//  
//
//  Created by Yusuke Hosonuma on 2020/07/16.
//

import Foundation

public struct Board<Cell> {
    public private(set) var size: Int
    public private(set) var cells: [Cell]
    
    /// Create blank board.
    /// - Parameters:
    ///   - size: side-length
    ///   - cell: blank cell (Important: `Cell` must by value-type)
    public init(size: Int, cell: Cell) {
        precondition(size > 0)
        
        self.size = size
        cells = Array(repeating: cell, count: size * size)
    }
    
    public init(size: Int, cells: [Cell]) {
        precondition(size * size == cells.count)
        
        self.size = size
        self.cells = cells
    }
    
    // TODO: 将来的には Board 自体を正方形に限定しないほうがいい、とは思ってる。
    
    public init(width: Int, height: Int, cells: [Cell], blank: @autoclosure () -> Cell) {
        precondition(width > 0 && height > 0)
        precondition(width * height == cells.count)

        self.size = max(width, height)
        
        let rows = cells.group(by: width)
        let diff = abs(width - height)
        
        let headCount = (diff / 2)
        let tailCount = diff - (diff / 2)

        if width > height {
            // Horizontally long
            let blankRow = Array(repeating: blank(), count: width)
            let topLines = Array(repeating: blankRow, count: headCount)
            let bottomLines = Array(repeating: blankRow, count: tailCount)
            self.cells = Array((topLines + rows + bottomLines).joined())
        } else {
            // Vertically long
            let newRows: [[Cell]] = rows.map { row in
                let left = Array(repeating: blank(), count: headCount)
                let right = Array(repeating: blank(), count: tailCount)
                return left + row + right
            }
            self.cells = Array(newRows.joined())
        }
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

    public func setBoard(toCenter board: Board<Cell>) -> Board<Cell> {
        precondition(board.size <= size)

        let offset = (size - board.size) / 2
        var newCells = cells
        
        for (y, row) in board.rows.enumerated() {
            for (x, cell) in row.enumerated() {
                let index = (offset + y) * self.size + (offset + x)
                newCells[index] = cell
            }
        }
        return Board(size: size, cells: newCells)
    }
    
    public func centering(by isBlank: (Cell) -> Bool) -> Board<Cell> {
        var diffX = rightLineCount(by: isBlank) - leftLineCount(by: isBlank)
        var diffY = bottomLineCount(by: isBlank) - topLineCount(by: isBlank)
        
        // Not need shift when diff size lower than 2
        diffX = abs(diffX) < 2 ? 0 : diffX
        diffY = abs(diffY) < 2 ? 0 : diffY

        let newCells = rows
            .map { $0.shifted(by: diffX / 2) }
            .shifted(by: diffY / 2)
            .joined()
        return Board(size: size, cells: Array(newCells))
    }
    
    // TODO: `size`と`count`といかにも間違いやすい感じがするがそのうち・・・
    
    public func extended(by cell: Cell, count: Int) -> Board<Cell> {
        let newSize = size + count * 2
        
        let newLine = Array(repeating: cell, count: newSize)
        let newLines = Array(repeating: newLine, count: count)
        
        let body: [[Cell]] = cells.group(by: size).map {
            let newEdge = Array(repeating: cell, count: count)
            return newEdge + $0 + newEdge
        }
        
        let cells = Array((newLines + body + newLines).joined())
        return Board(size: newSize, cells: cells)
    }
    
    public func contracted(count: Int) -> Board<Cell>? {
        guard size - count * 2 >= 1 else { return nil } // 1x1 より小さくはできない
        return trimLines(top: count, bottom: count, left: count, right: count)
    }

    public func trimed(by isBlank: (Cell) -> Bool) -> Board<Cell> {
        // 1x1 のときは何もせずに自身を返す
        guard size > 1 else { return self }
        
        // すべてブランクの場合、1x1のブランクな盤面を返す
        guard cells.filter(isBlank).count < cells.count else {
            return Board(size: 1, cells: [cells.first!])
        }
        
        let trimTopLeft = min(topLineCount(by: isBlank), leftLineCount(by: isBlank))
        let trimBottomRight = min(bottomLineCount(by: isBlank), rightLineCount(by: isBlank))
        
        let tempBoard = trimLines(top:    trimTopLeft,
                                  bottom: trimBottomRight,
                                  left:   trimTopLeft,
                                  right:  trimBottomRight)

        let trimBottomLeft = min(tempBoard.bottomLineCount(by: isBlank), tempBoard.leftLineCount(by: isBlank))
        let trimTopRight = min(tempBoard.topLineCount(by: isBlank), tempBoard.rightLineCount(by: isBlank))

        return tempBoard.trimLines(top:    trimTopRight,
                                   bottom: trimBottomLeft,
                                   left:   trimBottomLeft,
                                   right:  trimTopRight)
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
    
    // MARK: - Internal
    
    func isCentered(by isBlank: (Cell) -> Bool) -> Bool {
        let diffX = abs(leftLineCount(by: isBlank) - rightLineCount(by: isBlank))
        let diffY = abs(topLineCount(by: isBlank) - bottomLineCount(by: isBlank))
        return (0...1 ~= diffX) && (0...1 ~= diffY)
    }
    
    func topLineCount(by isBlank: (Cell) -> Bool) -> Int {
        rows
            .prefix(while: { $0.allSatisfy(isBlank) })
            .count
    }
    
    func bottomLineCount(by isBlank: (Cell) -> Bool) -> Int {
        rows
            .reversed()
            .prefix(while: { $0.allSatisfy(isBlank) })
            .count
    }
    
    func leftLineCount(by isBlank: (Cell) -> Bool) -> Int {
        rows
            .map { $0.prefix(while: isBlank).count }
            .min() ?? 0
    }
    
    func rightLineCount(by isBlank: (Cell) -> Bool) -> Int {
        rows
            .map { $0.reversed().prefix(while: isBlank).count }
            .min() ?? 0
    }
    
    // MARK: - Private
    
    private var rows: [[Cell]] {
        cells.group(by: size)
    }
    
    private func trimLines(top: Int, bottom: Int, left: Int, right: Int) -> Board<Cell> {
        assert(top + bottom == left + right)
        
        let newSize = size - (top + bottom)
        let newCells = rows
            .map { $0.dropFirst(left).dropLast(right) }
            .dropFirst(top)
            .dropLast(bottom)
            .joined()
        return Board(size: newSize, cells: Array(newCells))
    }
}

// MARK: - Equatable

extension Board: Equatable where Cell: Equatable {
    public static func == (lhs: Board<Cell>, rhs: Board<Cell>) -> Bool {
        lhs.size == rhs.size && lhs.cells == rhs.cells
    }
}

// MARK: - Codable

extension Board: Codable where Cell: Codable {}
