//
//  NoteViewController.swift
//  NoteApp
//
//  Created by Daniel on 24/05/2022.
//

import UIKit

class NoteViewController: UIViewController {
    
    @IBOutlet var noteLabel: UITextView!
    
    public var note: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteLabel.text = note

        // Do any additional setup after loading the view.
    }
    
}
