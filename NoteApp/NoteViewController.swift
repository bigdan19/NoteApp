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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonTapped))
        noteLabel.text = note
        titleLabel.text = titleOfNote
        guard let image = UIImage(named: "back.png") else {
            return
        }
        self.view.backgroundColor = UIColor(patternImage: image)
        noteLabel.layer.cornerRadius = 14
        noteLabel.textContainer.lineFragmentPadding = 15
    }
    
    @objc func shareButtonTapped() {
        if let title = titleLabel.text, let description = noteLabel.text {
            let textToShare = "NoteApp note ... \n\nTitle: \(title)\n\nDescription: \(description)"
            let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
            present(activityViewController, animated: true, completion: nil)
        } else {
            print("Error occured")
        }
    }
}
