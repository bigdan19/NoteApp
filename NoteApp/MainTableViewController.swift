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
    
    // Creating new Category for notes
    @objc func organizeButtonPressed() {
        let ac = UIAlertController(title: "Add Category", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Done", style: .default) { [unowned ac] _ in
            guard let name = ac.textFields![0].text else { return }
            self.datasource.append(("\(name)", []))
            self.tableView.reloadData()
        }
        ac.addAction(submitAction)
        ac.addAction(UIAlertAction(title: "cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    // Creating new note in choosen category
    @objc func addButtonPressed() {
        let ac = UIAlertController(title: "Choose Category", message: nil, preferredStyle: .actionSheet)
        for i in 0..<datasource.count {
            ac.addAction(UIAlertAction(title: "\(datasource[i].0)", style: .default, handler: chooseCategory))
        }
        ac.addAction(UIAlertAction(title: "cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    // function that is handling choosen category when creating new note
    func chooseCategory(action: UIAlertAction) {
        let ac = UIAlertController(title: "Write your note", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Done", style: .default) { [unowned self] _ in
            guard let text = ac.textFields![0].text else { return }
            for i in 0..<datasource.count {
                if datasource[i].0 == action.title! {
                    datasource[i].1.append(text)
                    self.tableView.reloadData()
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
    
    // setting title for every section
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return datasource[section].sectionName
    }

    // creating cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let note = datasource[indexPath.section].sectionElements[indexPath.row]
        cell.textLabel?.text = note
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
