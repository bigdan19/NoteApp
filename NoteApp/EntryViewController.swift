//
//  EntryViewController.swift
//  NoteApp
//
//  Created by Daniel on 24/05/2022.
//

import UIKit

class EntryViewController: UIViewController {
    @IBOutlet var noteField: UITextView!
    
    public var completion: ((String, String) -> Void)?
    
    private var formater = DateFormatter()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteField.becomeFirstResponder()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
    }
    
    @objc func didTapSave() {
        let today = Date.now
        formater.dateFormat = "'created on 'MM/dd/yyyy"
        let dateStr = formater.string(from: today)
        if let text = noteField.text, !text.isEmpty {
            completion?(text, dateStr)
        } else {
            let ac = UIAlertController(title: "Error", message: "Please type something", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
        }
        
    }
    
    
}
