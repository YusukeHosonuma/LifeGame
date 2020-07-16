//
//  File.swift
//  
//
//  Created by Yusuke Hosonuma on 2020/07/16.
//

import Foundation

struct Board<Cell> {
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
}
