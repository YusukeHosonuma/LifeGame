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
    
    func shifted(by: Int) -> [Element] {
        guard count > 0 && abs(by) > 0 else { return self }
        
        let size = abs(by) % count
        
        if 0 < by {
            let xs = self[(count - size)..<count]
            return Array(xs + dropLast(size))
        } else {
            let xs = self[0..<size]
            return Array(dropFirst(size) + xs)
        }
    }
}
