//
//  MainTableViewController.swift
//  NoteApp
//
//  Created by Daniel on 15/05/2022.
//

import UIKit

class MainTableViewController: UITableViewController {

    // OUR database for this current stage
    var datasource: [(sectionName: String, sectionElements: [String])] =
    [
        ("Work", ["Brush floor", "finish courses", "check rota"]),
        ("Home", ["mop floor", "make laudry", "wash dishes"])
    ]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(organizeButtonPressed))
        
    }
    
    func showErrorMessage(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
    
    
    // Creating new Category for notes
    @objc func organizeButtonPressed() {
        let ac = UIAlertController(title: "Add Category", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Create", style: .default) { [unowned ac] _ in
            guard let name = ac.textFields![0].text else { return }
            if name == "" {
                self.showErrorMessage(title: "Error", message: "Category name can't be empty")
            } else {
                self.datasource.append(("\(name)", []))
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        }
        ac.addAction(submitAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    
    // Creating new note in choosen category
    @objc func addButtonPressed() {
        let ac = UIAlertController(title: "Choose Category", message: nil, preferredStyle: .actionSheet)
        for i in 0..<datasource.count {
            ac.addAction(UIAlertAction(title: "\(datasource[i].0)", style: .default, handler: choosenCategory))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    
    // Function that is handling choosen category when creating new note
    func choosenCategory(action: UIAlertAction) {
        let ac = UIAlertController(title: "Write your note", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Create", style: .default) { [unowned self] _ in
            guard let text = ac.textFields![0].text else { return }
            if text == "" {
                showErrorMessage(title: "Error", message: "New note can't be empty")
            } else {
                for i in 0..<datasource.count {
                    if datasource[i].0 == action.title! {
                        datasource[i].1.append(text)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
            
        }
        ac.addAction(submitAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }

    // Setting number of sections in tableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return datasource.count
    }

    // Setting number of rows in each section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource[section].sectionElements.count
    }
    
    // Setting title for every section
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return datasource[section].sectionName
        return "\(datasource[section].sectionName + " (\(datasource[section].1.count))")"
    }

    // Creating cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let note = datasource[indexPath.section].sectionElements[indexPath.row]
        cell.textLabel?.text = note
        return cell
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            // Deleting item from our database
            
            datasource[indexPath.section].1.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // Checking if there is no more notes in a category - remove category
            if datasource[indexPath.section].1.count == 0 {
                datasource.remove(at: indexPath.section)
                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
            }
            tableView.endUpdates()
            
            // Reloading tableView data after 0.3 sec
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3 ){
                self.tableView.reloadData()
            }
        }
    }

}


// TODO: Potencially deleting a category from database if amount of notes are = 0
// Updating the UI
