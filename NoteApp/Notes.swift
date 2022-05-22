//
//  Notes.swift
//  NoteApp
//
//  Created by Daniel on 22/05/2022.
//

import Foundation


struct Notes: Codable {
    var sectionName: String
    var sectionElements: [String]
}

struct NotesArr: Codable {
    var arrayOfNotes: [Notes]
}
