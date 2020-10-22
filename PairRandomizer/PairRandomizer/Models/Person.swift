//
//  Person.swift
//  PairRandomizer
//
//  Created by Austin Goetz on 10/21/20.
//

import Foundation

class Person: Codable {
    let name: String
    
    init(name: String) {
        self.name = name
    }
}

// MARK: - Extensions
extension Person: Equatable {
    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs === rhs
    }
}
