//
//  PersonController.swift
//  PairRandomizer
//
//  Created by Austin Goetz on 10/21/20.
//

import Foundation

class PersonController {
    
    // MARK: - Properties
    /// Shared Instance
    static let shared = PersonController()
    /// Source of Truth
    var people: [Person] = []
    
    // MARK: - CRUD
    func addPersonWith(name: String) {
        let newPerson = Person(name: name)
        people.append(newPerson)
    }
}
