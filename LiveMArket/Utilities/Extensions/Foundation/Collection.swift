//
//  Collection.swift
//  
//
//  Created by Muneeb on 05/10/2021.
//

import Foundation
extension Collection {
    subscript(safe index: Index) -> Iterator.Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}
