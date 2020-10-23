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
    /// Source of Truth for all created Person objects
//    var people: [Person] = []
    /// Source of Truth for all pair groups
    var pairs: [[Person]] = []
    
    // MARK: - CRUD
    // Create
    func createPersonWith(name: String) {
        let newPerson = Person(name: name)
        
        addToPair(person: newPerson)
        saveToPersistentStore()
    }
    
    /// Adds the passed through person into a pair stored in the pairs array
    /// - Parameter person: The object to be added to a pair and saved
    func addToPair(person: Person) {
        // If there's nothing in the SoT, we can just add as a new array containing the person passed in
        if self.pairs.count == 0 {
            self.pairs.append([person])
            // We can return because we don't want to run our look and check to see if the count is less than 2. We know what's there
            return
        }
        // Declare a property that
        var n = 0
        for pair in self.pairs {
            if pair.count < 2 {
                self.pairs[n].append(person)
                return
            }
            n += 1
        }
        self.pairs.append([person])
        saveToPersistentStore()
    }
    
    // Delete
    func deletePersonAtIndex(section: Int, row: Int) {
        pairs[section].remove(at: row)
        
        if pairs[section].count == 1 {
            let oldPartner = pairs[section][0]
            pairs.remove(at: section)
            addToPair(person: oldPartner)
        }
        
        saveToPersistentStore()
    }
    
    // MARK: - Helpers
    func shuffleNames() {
        var placeholderArray: [Person] = []
        for pair in self.pairs {
            for person in pair {
                placeholderArray.append(person)
            }
        }
        self.pairs = []
        
        let shuffledArray = placeholderArray.shuffled()
        for person in shuffledArray {
            addToPair(person: person)
        }
        
        saveToPersistentStore()
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
            let pairsJSON = try encoder.encode(self.pairs)
            try pairsJSON.write(to: fileURLForPersistentStore())
        } catch {
            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
        }
    }
    
    // Load
    func loadFromPersistentStore() {
        let decoder = JSONDecoder()
        
        do {
            let jsonData = try Data(contentsOf: fileURLForPersistentStore())
            let decodedPairs = try decoder.decode([[Person]].self, from: jsonData)
            
            self.pairs = decodedPairs
        } catch {
            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
        }
    }
}
