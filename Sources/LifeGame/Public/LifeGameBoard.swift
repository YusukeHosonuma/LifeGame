//
//  File.swift
//  
//
//  Created by Yusuke Hosonuma on 2020/07/15.
//

// Ref:
// https://simple.wikipedia.org/wiki/Conway%27s_Game_of_Life

public struct LifeGameBoard {
    private var board: Board<Cell>
    
    // MARK: Computed Properties
    
    public var size: Int {
        board.size
    }
    
    public var cells: [Cell] {
        board.cells
    }
    
    public var rows: [[Cell]] {
        board.cells.group(by: size)
    }
    
    // MARK: Initializer
    
    // TODO: `Board`を受け取るインターフェースに変更したい。
    
    public init(size: Int, cells: [Cell]) {
        board = Board(size: size, cells: cells)
    }

    public init(size: Int, cells: [Int]) {
        board = Board(size: size, cells: cells.map { $0 >= 1 ? .alive : .die })
    }

    public init(size: Int) {
        board = Self.emptyBoard(size: size)
    }

    // MARK: Public
    
    public mutating func next() {
        let cells = board.cells.enumerated().map { index, _ in nextCellState(index) }
        self.board = Board(size: size, cells: cells)
    }
    
    public mutating func toggle(x: Int, y: Int) {
        let index = x + y * size
        board[index] = board[index] == .alive ? .die : .alive
    }
    
    public mutating func clear() {
        board = Self.emptyBoard(size: size)
    }
    
    public mutating func apply(size: Int, cells: [Int]) {
        board.apply(Board(size: size, cells: cells.map { $0 >= 1 ? .alive : .die }))
    }
    
    // MARK: Private

    private static func emptyBoard(size: Int) -> Board<Cell> {
        Board(size: size, cells: Array(repeating: .die, count: size * size))
    }

    private func nextCellState(_ index: Int) -> Cell {
        let aliveCount = board.surroundingCells(index: index).filter { $0 == .alive }.count
        return board[index].next(surroundingAliveCount: aliveCount)
    }
}
