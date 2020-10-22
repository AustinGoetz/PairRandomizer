//
//  ListTableViewController.swift
//  PairRandomizer
//
//  Created by Austin Goetz on 10/21/20.
//

import UIKit

class ListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        PersonController.shared.loadFromPersistentStore()
        PersonController.shared.createPairs()
    }
    
    // MARK: - Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        presentAlertController()
    }
    
    @IBAction func randomButtonTapped(_ sender: Any) {
        PersonController.shared.shuffleNames()
        PersonController.shared.createPairs()
        self.tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return PersonController.shared.pairs.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Group \(section + 1)"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PersonController.shared.pairs[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath)

        let personToDisplay = PersonController.shared.pairs[indexPath.section][indexPath.row]
        cell.textLabel?.text = personToDisplay.name

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let personToDelete = PersonController.shared.people[indexPath.row]
            PersonController.shared.pairs[indexPath.section].remove(at: indexPath.row)
            PersonController.shared.remove(person: personToDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            if PersonController.shared.pairs[indexPath.section].count == 0 {
                PersonController.shared.pairs.remove(at: indexPath.section)
                tableView.deleteSections([indexPath.section], with: .fade)
            }
        }
    }
    
    // MARK: - Class Functions
    func presentAlertController() {
        let alertController = UIAlertController(title: "Add a name to the list", message: "Would be fun to do a Jazz player!", preferredStyle: .alert)
        alertController.addTextField { (nameTextField) in
            nameTextField.placeholder = "Enter name"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let text = alertController.textFields?.first?.text, !text.isEmpty else { return }
            // Adds person to the people SoT
            PersonController.shared.addPersonWith(name: text)
            // Creates pairs from the SoT and stores in pairs property
            PersonController.shared.createPairs()
            // Perhaps move this later
            self.tableView.reloadData()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
