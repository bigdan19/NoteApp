//
//  MainTableViewController.swift
//  NoteApp
//
//  Created by Daniel on 15/05/2022.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    let defaults = UserDefaults.standard
    
    var mainData: ArrayOfSectionsWithNotes = ArrayOfSectionsWithNotes(arrayOfNotes: [])
    var simpleArrayOfData: [Note] = []
    var filteredData: [Note] = []
    
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
        decodeData()
        createDictOfDataForFiltering()
        createUI()
    }
    
    
    
    // creating UI ( navigation items, etc )
    func createUI() {
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "back.png"))
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonPressed))
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Notes"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        configureKeyboardToolbar()
    }
    
    func configureKeyboardToolbar() {
        let organize = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(createCategoryButtonPressed))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let add = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(createNewNoteButtonPressed))
        toolbarItems = [organize, flexibleSpace, add]
        
    }
    
    
    // encoding data to save in userDefaults
    func encodeData() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(mainData) {
            defaults.set(encoded, forKey: "SavedData")
        }
    }
    
    // decoding data to load it from userDefaults
    func decodeData() {
        if let savedData = defaults.object(forKey: "SavedData") as? Data {
            let decoder = JSONDecoder()
            if let loadedData = try? decoder.decode(ArrayOfSectionsWithNotes.self, from: savedData){
                mainData = loadedData
            }
        }
    }
    
    
    
    // custom UIAlert showing different errors
    func showErrorMessage(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
    
    @objc func editButtonPressed() {
        if (self.tableView.isEditing == true) {
            self.tableView.isEditing = false
            self.navigationItem.rightBarButtonItem?.title = "Edit"
        } else {
            self.tableView.isEditing = true
            self.navigationItem.rightBarButtonItem?.title = "Done"
        }
    }
    
    
    
    // Creating new Category for notes
    @objc func createCategoryButtonPressed() {
        let ac = UIAlertController(title: "Add Category", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Create", style: .default) { [unowned ac] _ in
            guard let name = ac.textFields![0].text else { return }
            if name == "" {
                self.showErrorMessage(title: "Error", message: "Category name can't be empty")
            } else {
                // creating new Note for newly created category
                self.choosenCategory(action: UIAlertAction(title: "\(name)", style: .default))
                self.mainData.arrayOfNotes.append(SectionWithNotes(sectionName: "\(name)", sectionNotesArr: []))
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
    
    
    
    // Creating new note and choosing under which category
    @objc func createNewNoteButtonPressed() {
        if mainData.arrayOfNotes.isEmpty {
            showErrorMessage(title: "Error", message: "Please create at least one category")
        } else {
            let ac = UIAlertController(title: "Choose Category", message: nil, preferredStyle: .actionSheet)
            for i in 0..<mainData.arrayOfNotes.count {
                ac.addAction(UIAlertAction(title: "\(mainData.arrayOfNotes[i].sectionName)", style: .default, handler: choosenCategory))
            }
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
            present(ac, animated: true)
        }
    }
    
    
    
    // Function that is handling choosen category when creating new note
    func choosenCategory(action: UIAlertAction) {
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "new") as? EntryViewController else { return }
        vc.title = "New Note"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { title, note, date in
            self.navigationController?.popToRootViewController(animated: true)
            for i in 0..<self.mainData.arrayOfNotes.count {
                if self.mainData.arrayOfNotes[i].sectionName == action.title! {
                    self.mainData.arrayOfNotes[i].sectionNotesArr.append(Note(title: title, note: note, date: date))
                    self.createDictOfDataForFiltering()
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.encodeData()
                    }
                }
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    // Setting number of sections in tableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering {
            return 1
        }
        return mainData.arrayOfNotes.count
    }
    
    
    
    // Setting number of rows in each section of tableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredData.count
        }
        return mainData.arrayOfNotes[section].sectionNotesArr.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if !isFiltering {
            guard let header = view as? UITableViewHeaderFooterView else { return }
            header.textLabel?.textColor = .darkGray
            header.textLabel?.font = UIFont(name: "Georgia Bold", size: 28)
//            header.textLabel?.font = UIFont.boldSystemFont(ofSize: 28)
            header.textLabel?.frame = header.bounds.offsetBy(dx: 30, dy: 0)
        }
    }
    
    
    
    // Setting title for every section in tableView
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isFiltering { return nil }
        else {
            return "\(mainData.arrayOfNotes[section].sectionName)"
        }
    }
    
    
    // Creating cell in tableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        let note: Note
        if isFiltering {
            note = filteredData[indexPath.row]
        } else {
            note = mainData.arrayOfNotes[indexPath.section].sectionNotesArr[indexPath.row]
        }
        cell.cellTitle.text = note.title
        cell.cellText.text = note.note
        cell.cellDate.text = note.date
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFiltering {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "note") as? NoteViewController else { return }
            let note = filteredData[indexPath.row]
            vc.navigationItem.largeTitleDisplayMode = .never
            vc.title = "Note"
            vc.note = note.note
            vc.titleOfNote = note.title
            navigationController?.pushViewController(vc, animated: true)
        } else {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "note") as? NoteViewController else { return }
            let note = mainData.arrayOfNotes[indexPath.section].sectionNotesArr[indexPath.row]
            vc.navigationItem.largeTitleDisplayMode = .never
            vc.title = "Note"
            vc.note = note.note
            vc.titleOfNote = note.title
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    // editing tableView
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if isFiltering {
            
        } else {
            if editingStyle == .delete {
                deleteCell(indexPath: indexPath)
            }
        }
    }
    
    func deleteCell(indexPath: IndexPath) {
        tableView.beginUpdates()
        
        // Deleting item from our database
        mainData.arrayOfNotes[indexPath.section].sectionNotesArr.remove(at: indexPath.row)
        createDictOfDataForFiltering()
        tableView.deleteRows(at: [indexPath], with: .fade)
        
        
        // Checking if there is no more notes in a category - remove category
        if mainData.arrayOfNotes[indexPath.section].sectionNotesArr.count == 0 {
            mainData.arrayOfNotes.remove(at: indexPath.section)
            tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
        }
        tableView.endUpdates()
        
        // Reloading tableView data after 0.3 sec
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3 ){
            self.tableView.reloadData()
            self.encodeData()
        }
    }
    
    // filtering function
    func filterContentForSearchText(_ searchText: String) {
        
        filteredData = simpleArrayOfData.filter({ (element: Note) -> Bool in
            return element.title.lowercased().contains(searchText.lowercased())
        })
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    
    // creating regular array of notes without section for searchbar to work with
    func createDictOfDataForFiltering() {
        simpleArrayOfData = []
        for i in 0..<mainData.arrayOfNotes.count {
            for j in 0..<mainData.arrayOfNotes[i].sectionNotesArr.count {
                simpleArrayOfData.append(mainData.arrayOfNotes[i].sectionNotesArr[j])
            }
        }
    }
    
}


extension MainTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}
