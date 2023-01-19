//
//  NoteViewController.swift
//  NoteApp
//
//  Created by Daniel on 24/05/2022.
//

import UIKit

class NoteViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var noteLabel: UITextView!
    
    public var note: String = ""
    public var titleOfNote: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteLabel.text = note
        titleLabel.text = titleOfNote
        guard let image = UIImage(named: "back.jpg") else {
            return
        }
        self.view.backgroundColor = UIColor(patternImage: image)
        noteLabel.layer.cornerRadius = 14
    }
    
}
