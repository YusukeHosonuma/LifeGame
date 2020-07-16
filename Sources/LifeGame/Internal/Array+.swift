//
//  File.swift
//  
//
//  Created by Yusuke Hosonuma on 2020/07/16.
//

extension Array {
    func group(by size: Int) -> [[Element]] {
        assert(size > 0)
        
        var offset: Int = 0
        var result: [[Element]] = []
        while offset < count {
            let endIndex = Swift.min(offset + size, self.count)
            result.append(Array(self[offset..<endIndex]))
            offset += size
        }
        return result
    }
}
