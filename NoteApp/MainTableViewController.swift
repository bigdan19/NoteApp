//
//  MainTableViewController.swift
//  NoteApp
//
//  Created by Daniel on 15/05/2022.
//

import UIKit
import MaterialComponents.MaterialDialogs
import MaterialComponents.MaterialBanner
import MaterialComponents.MaterialTextControls_FilledTextAreas
import MaterialComponents.MaterialTextControls_FilledTextFields
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import MaterialComponents.MaterialTextControls_OutlinedTextFields
import CoreData

var noteList = [Note]()

class MainTableViewController: UITableViewController {
    
    var firstLoad = true
    
    let defaults = UserDefaults.standard
    
    var mainData: NotesArr = NotesArr(arrayOfNotes: [])
    var simpleArrayOfData: [Elements] = []
    var filteredData: [Elements] = []
    
    var dateFormatter = DateFormatter()
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        decodeData()
//        createDictOfDataForFiltering()
        if (firstLoad) {
            firstLoad = false
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            do
            {
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results
                {
                    let note = result as! Note
                    noteList.append(note)
                }
            }
            catch
            {
                print("Fetch Failed")
            }
        }
        createUI()
    }
    
    
    
    // creating UI ( navigation items, etc )
    func createUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonPressed))
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Notes"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        configureKeyboardToolbar()
    }
    
    func configureKeyboardToolbar() {
        let organize = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(organizeButtonPressed))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let add = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(composeButtonPressed))
        toolbarItems = [organize, flexibleSpace, add]
    }
    
    
    // encoding data to save in userDefaults
//    func encodeData() {
//        let encoder = JSONEncoder()
//        if let encoded = try? encoder.encode(mainData) {
//            defaults.set(encoded, forKey: "SavedData")
//        }
//    }
    
    // decoding data to load it from userDefaults
//    func decodeData() {
//        if let savedData = defaults.object(forKey: "SavedData") as? Data {
//            let decoder = JSONDecoder()
//            if let loadedData = try? decoder.decode(NotesArr.self, from: savedData){
//                mainData = loadedData
//            }
//        }
//    }
    
    
    // custom UIAlert showing different errors
//    func showErrorMessage(title: String, message: String) {
//
//        let alertController = MDCAlertController(title: title, message: message)
//        let action = MDCAlertAction(title: "OK") { (action) in print("OK") }
//        alertController.addAction(action)
//        alertController.cornerRadius = 10
//        present(alertController, animated: true)
//    }
    
//    @objc func editButtonPressed() {
//        if (self.tableView.isEditing == true) {
//            self.tableView.isEditing = false
//            self.navigationItem.rightBarButtonItem?.title = "Edit"
//        } else {
//            self.tableView.isEditing = true
//            self.navigationItem.rightBarButtonItem?.title = "Done"
//        }
//    }
    
    
    
    // Creating new Category for notes
    @objc func organizeButtonPressed() {
        
        let ac = UIAlertController(title: "Add Category", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Create", style: .default) { [unowned ac] _ in
            guard let name = ac.textFields![0].text else { return }
            if name == "" {
//                self.showErrorMessage(title: "Empty", message: "Category name can't be empty")
            } else {
                // creating new Note for newly created category
                self.choosenCategory()
                self.mainData.arrayOfNotes.append(Notes(sectionName: "\(name)", sectionElements: []))
                DispatchQueue.main.async {
                    self.tableView.reloadData()
//                    self.encodeData()
                }
            }
            
        }
        ac.addAction(submitAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    
    
    // Creating new note in choosen category
    @objc func composeButtonPressed() {
//        if mainData.arrayOfNotes.isEmpty {
////            showErrorMessage(title: "No category", message: "Please create at least one category")
//        } else {
//            let ac = UIAlertController(title: "Choose Category", message: nil, preferredStyle: .actionSheet)
//            for i in 0..<mainData.arrayOfNotes.count {
//                ac.addAction(UIAlertAction(title: "\(mainData.arrayOfNotes[i].sectionName)", style: .default, handler: choosenCategory))
//            }
//            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//            ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
//            present(ac, animated: true)
//        }
        choosenCategory()
    }
    
    
    
    // Function that is handling choosen category when creating new note
    func choosenCategory() {
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "new") as? EntryViewController else { return }
        vc.title = "New Note"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { note, date in
            self.navigationController?.popToRootViewController(animated: true)
//            for i in 0..<self.mainData.arrayOfNotes.count {
//                if self.mainData.arrayOfNotes[i].sectionName == action.title! {
//                    self.mainData.arrayOfNotes[i].sectionElements.append(Elements(note: note, date: date))
//                    self.createDictOfDataForFiltering()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Note", in: context)
            let newNote = Note(entity: entity!, insertInto: context)
            
            newNote.id = noteList.count as NSNumber
            newNote.desc = note as NSString
            newNote.date = date as NSString
            
            do
            {
                try context.save()
                noteList.append(newNote)
            }
            catch
            {
                print("context save error")
            }
            
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
//                        self.encodeData()
                    }
                }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    // Setting number of sections in tableView
    override func numberOfSections(in tableView: UITableView) -> Int {
//        if isFiltering {
//            return 1
//        }
//        return mainData.arrayOfNotes.count
        return 1
    }
    
    
    
    // Setting number of rows in each section of tableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if isFiltering {
//            return filteredData.count
//        }
//        return mainData.arrayOfNotes[section].sectionElements.count
        return noteList.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if !isFiltering {
            guard let header = view as? UITableViewHeaderFooterView else { return }
            header.textLabel?.textColor = .black
            header.textLabel?.font = UIFont.boldSystemFont(ofSize: 24)
            header.textLabel?.frame = header.bounds.offsetBy(dx: 20, dy: 0)
        }
    }
    
    
    
    // Setting title for every section in tableView
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if isFiltering { return nil }
//        else {
//            return "\(mainData.arrayOfNotes[section].sectionName)"
//        }
//    }
    
    
    // Creating cell in tableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        let note: Elements
//        if isFiltering {
//            note = filteredData[indexPath.row]
//            cell.detailTextLabel?.text = filteredData[indexPath.row].date
//        } else {
//            note = mainData.arrayOfNotes[indexPath.section].sectionElements[indexPath.row]
//            cell.detailTextLabel?.text = mainData.arrayOfNotes[indexPath.section].sectionElements[indexPath.row].date
//        }
        let thisNote: Note!
        thisNote = noteList[indexPath.row]
//        cell.textLabel?.text = note.note
        cell.textLabel?.text = thisNote.desc as String?
        cell.detailTextLabel?.text = thisNote.date as String?
    
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
        cell.layer.borderWidth = 0.1
        cell.layer.borderColor = CGColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "note") as? NoteViewController else { return }
//        let note = noteList[indexPath.row]
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = "Note"
        let indexPath = tableView.indexPathForSelectedRow!
        
        let selectedNote: Note!
        selectedNote = noteList[indexPath.row]
        vc.selectedNote = selectedNote
        tableView.deselectRow(at: indexPath, animated: true)
//        vc.note = note.desc as String
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    // editing tableView
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if isFiltering {
            
        } else {
            if editingStyle == .delete {
                tableView.beginUpdates()
                
                // Deleting item from our database
                mainData.arrayOfNotes[indexPath.section].sectionElements.remove(at: indexPath.row)
                createDictOfDataForFiltering()
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                
                // Checking if there is no more notes in a category - remove category
                if mainData.arrayOfNotes[indexPath.section].sectionElements.count == 0 {
                    mainData.arrayOfNotes.remove(at: indexPath.section)
                    tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
                }
                tableView.endUpdates()
                
                // Reloading tableView data after 0.3 sec
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3 ){
                    self.tableView.reloadData()
//                    self.encodeData()
                }
            }
        }
    }
    
    
    // filtering function
    func filterContentForSearchText(_ searchText: String) {
        
        filteredData = simpleArrayOfData.filter({ (element: Elements) -> Bool in
            return element.note.lowercased().contains(searchText.lowercased())
        })
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    
    // creating regular array of notes without section for searchbar to work with
    func createDictOfDataForFiltering() {
        simpleArrayOfData = []
        for i in 0..<mainData.arrayOfNotes.count {
            for j in 0..<mainData.arrayOfNotes[i].sectionElements.count {
                simpleArrayOfData.append(mainData.arrayOfNotes[i].sectionElements[j])
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
}


extension MainTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}
