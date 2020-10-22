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
    // Create
    func addPersonWith(name: String) {
        let newPerson = Person(name: name)
        people.append(newPerson)
        
        saveToPersistentStore()
    }
    
    // Delete
    func remove(person: Person) {
        guard let indexPathOfPersonToRemove = people.firstIndex(of: person) else { return }
        people.remove(at: indexPathOfPersonToRemove)
        
        saveToPersistentStore()
    }
    
    // MARK: - Helpers
    func shuffleNames() {
        let arrayToShuffle = people
        let shuffledArray = arrayToShuffle.shuffled()
        people = shuffledArray
    }
    
    // MARK: - Persistence
    // Create
    fileprivate func fileURLForPersistentStore() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileURL = urls[0].appendingPathComponent("PairRandomizer.json")
        
        return fileURL
    }
    
    // Save
    func saveToPersistentStore() {
        let encoder = JSONEncoder()
        
        do {
            let peopleJSON = try encoder.encode(people)
            try peopleJSON.write(to: fileURLForPersistentStore())
        } catch {
            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
        }
    }
    
    // Load
    func loadFromPersistentStore() {
        let decoder = JSONDecoder()
        
        do {
            let jsonData = try Data(contentsOf: fileURLForPersistentStore())
            let decodedPeople = try decoder.decode([Person].self, from: jsonData)
            
            people = decodedPeople
        } catch {
            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
        }
    }
}
