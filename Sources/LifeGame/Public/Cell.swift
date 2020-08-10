//
//  File.swift
//  
//
//  Created by Yusuke Hosonuma on 2020/07/16.
//

public enum Cell: Int {
    case die
    case alive
    
    func next(surroundingAliveCount count: Int) -> Cell {
        assert((0...8).contains(count)) // Because max of surrouding cell counts are 8
        
        switch self {
        case .alive:
            if count == 2 || count == 3 {
                return .alive
            } else {
                return .die
            }
        case .die:
            if count == 3 {
                return .alive
            } else {
                return .die
            }
        }
    }
}

// MARK: - Codable

extension Cell: Codable {}
