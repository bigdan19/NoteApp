//
//  EntryViewController.swift
//  NoteApp
//
//  Created by Daniel on 24/05/2022.
//

import UIKit
import MaterialComponents.MaterialDialogs

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
            showErrorMessage(title: "No text", message: "New note cannot be empty")
        }
    }
    
    func showErrorMessage(title: String, message: String) {
        let alertController = MDCAlertController(title: title, message: message)
        let action = MDCAlertAction(title: "OK") { (action) in print("OK") }
        alertController.addAction(action)
        alertController.cornerRadius = 10
        present(alertController, animated: true)
    }
    
    
}
