//
//  MainTableViewController.swift
//  NoteApp
//
//  Created by Daniel on 15/05/2022.
//

import UIKit

class MainTableViewController: UITableViewController {

    // OUR database for this current stage
//    var dataSource: [(sectionName: String, sectionElements: [String])] =
//    [
//        ("Work", ["Brush floor", "finish courses", "check rota"]),
//        ("Home", ["mop floor", "make laudry", "wash dishes"])
//    ]
//    var dataSource: [(sectionName: String, sectionElements: [String])] = []
    
    let defaults = UserDefaults.standard
    
    var data: NotesArr = NotesArr(arrayOfNotes: [])
    
    
    
//    var data: NotesArr = NotesArr(arrayOfNotes: [Notes(sectionName: "Work", sectionElements: ["Brush floor", "finish courses", "check rota"]), Notes(sectionName: "Home", sectionElements: ["mop floor", "make laudry", "wash dishes"])])
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        decodeData()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(organizeButtonPressed))
    }
    
    func encodeData() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(data) {
            defaults.set(encoded, forKey: "SavedData")
        }
    }
    
    func decodeData() {
        if let savedData = defaults.object(forKey: "SavedData") as? Data {
            let decoder = JSONDecoder()
            if let loadedData = try? decoder.decode(NotesArr.self, from: savedData){
                data = loadedData
            }
        }
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
                self.data.arrayOfNotes.append(Notes(sectionName: "\(name)", sectionElements: []))
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.encodeData()
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
        for i in 0..<data.arrayOfNotes.count {
            ac.addAction(UIAlertAction(title: "\(data.arrayOfNotes[i].sectionName)", style: .default, handler: choosenCategory))
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
                for i in 0..<data.arrayOfNotes.count {
                    
                    if data.arrayOfNotes[i].sectionName == action.title! {
                        data.arrayOfNotes[i].sectionElements.append(text)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.encodeData()
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
        return data.arrayOfNotes.count
    }

    // Setting number of rows in each section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.arrayOfNotes[section].sectionElements.count
    }
    
    // Setting title for every section
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return dataSource[section].sectionName
        return "\(data.arrayOfNotes[section].sectionName + " (\(data.arrayOfNotes[section].sectionElements.count))")"
    }

    // Creating cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let note = data.arrayOfNotes[indexPath.section].sectionElements[indexPath.row]
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
            
            data.arrayOfNotes[indexPath.section].sectionElements.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            
            // Checking if there is no more notes in a category - remove category
            
            if data.arrayOfNotes[indexPath.section].sectionElements.count == 0 {
                data.arrayOfNotes.remove(at: indexPath.section)
                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
            }
            
            tableView.endUpdates()
            // Reloading tableView data after 0.3 sec
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3 ){
                self.tableView.reloadData()
                self.encodeData()
            }
        }
    }

}
