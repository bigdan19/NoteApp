//
//  EntryViewController.swift
//  NoteApp
//
//  Created by Daniel on 24/05/2022.
//

import UIKit

class EntryViewController: UIViewController {
    @IBOutlet var noteField: UITextView!
    
    public var completion: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteField.becomeFirstResponder()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
    }
    
    @objc func didTapSave() {
        if let text = noteField.text, !text.isEmpty {
            completion?(text)
        }
    }
    

}
