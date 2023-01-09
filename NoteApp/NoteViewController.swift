//
//  NoteViewController.swift
//  NoteApp
//
//  Created by Daniel on 24/05/2022.
//

import UIKit
import CoreData

class NoteViewController: UIViewController {
    
    @IBOutlet var noteLabel: UITextView!
    
    public var note: String = ""
    public var selectedNote: Note? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
//        noteLabel.text = note
        if (selectedNote != nil)
        {
            noteLabel.text = selectedNote?.desc as String?
        }
    }
    
    @objc func didTapSave(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        do
        {
            let results:NSArray = try context.fetch(request) as NSArray
            for result in results
            {
                let note = result as! Note
                if (note == selectedNote)
                {
                    note.desc = noteLabel.text as NSString?
                    try context.save()
                    navigationController?.popViewController(animated: true)
                }
            }
        }
        catch
        {
            print("Fetch failed")
        }
    }
    
}
