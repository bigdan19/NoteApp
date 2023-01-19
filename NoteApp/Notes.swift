//
//  Notes.swift
//  NoteApp
//
//  Created by Daniel on 22/05/2022.
//

import Foundation


struct Notes: Codable {
    var sectionName: String
    var sectionElements: [Elements]
}

struct NotesArr: Codable {
    var arrayOfNotes: [Notes]
}

struct Elements: Codable {
    var title: String
    var note: String
    var date: String
}
