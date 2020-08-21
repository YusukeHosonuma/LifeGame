//
//  File.swift
//  
//
//  Created by Yusuke Hosonuma on 2020/07/15.
//

// Ref:
// https://simple.wikipedia.org/wiki/Conway%27s_Game_of_Life

public struct LifeGameBoard {
    public private(set) var board: Board<Cell>
    public private(set) var generation: Int = 0

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
    
    // MARK: Static
    
    public static func random(size: Int) -> LifeGameBoard {
        var generator = SystemRandomNumberGenerator()
        return LifeGameBoard.random(size: size, using: &generator)
    }
    
    public static func random<T>(size: Int, using generator: inout T) -> LifeGameBoard where T: RandomNumberGenerator {
        let cells: [Cell] = (0 ..< size * size).map { _ in Bool.random(using: &generator) ? .alive : . die }
        return LifeGameBoard(board: Board(size: size, cells: cells))
    }
    
    // MARK: Initializer
    
    // TODO: `Board`を受け取るインターフェースに変更したい。

    public init(size: Int) {
        board = Self.emptyBoard(size: size)
    }

    public init(board: Board<Cell>) {
        self.board = board
    }

    @available(*, deprecated, message: "Please use to `init(board: Board<Cell>)` instead.")
    public init(size: Int, cells: [Cell]) {
        board = Board(size: size, cells: cells)
    }

    @available(*, deprecated, message: "Please use to `init(board: Board<Cell>)` instead.")
    public init(size: Int, cells: [Int]) {
        board = Board(size: size, cells: cells.map { $0 >= 1 ? .alive : .die })
    }
    
    // MARK: Public
    
    public mutating func next() {
        let cells = board.cells.enumerated().map { index, _ in nextCellState(index) }
        self.board = Board(size: size, cells: cells)
        generation += 1
    }
    
    public mutating func toggle(x: Int, y: Int) {
        let index = x + y * size
        board[index] = board[index] == .alive ? .die : .alive
    }
    
    public mutating func clear() {
        board = Self.emptyBoard(size: size)
        generation = 0
    }
    
    public mutating func apply(size: Int, cells: [Int]) {
        board.apply(Board(size: size, cells: cells.map { $0 >= 1 ? .alive : .die }))
    }
    
    public mutating func changeBoardSize(to newSize: Int) {
        precondition((size - newSize) % 2 == 0, "diff size must be even")
        if newSize > size {
            board = board.extended(by: .die, count: (newSize - size) / 2)
        } else {
            board = board.contracted(count: (size - newSize) / 2)!
        }
        // TODO: `generation` はクリアすべきなのか・・・触っていて不自然だったら直すかも。
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

extension LifeGameBoard: CustomStringConvertible {
    public var description: String {
        board.cells
            .map { $0 == .alive ? "■" : "□" }
            .group(by: board.size)
            .map { $0.joined(separator: " ") }
            .joined(separator: "\n")
    }
}
