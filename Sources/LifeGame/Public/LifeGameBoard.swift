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
    
    public init(size: Int, cells: [Cell]) {
        self.board = Board(size: size, cells: cells)
    }

    public init(size: Int) {
        self.init(size: size, cells: Array(repeating: .die, count: size * size))
    }

    public init(size: Int, cells: [Int]) {
        self.init(size: size, cells: cells.map { $0 == 1 ? .alive : .die })
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
    
    // MARK: Private
    
    private func nextCellState(_ index: Int) -> Cell {
        let aliveCount = board.surroundingCells(index: index).filter { $0 == .alive }.count
        return board[index].next(surroundingAliveCount: aliveCount)
    }
}
