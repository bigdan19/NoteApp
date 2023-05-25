//
//  Notes.swift
//  NoteApp
//
//  Created by Daniel on 22/05/2022.
//

import Foundation


struct Note: Codable {
    var title: String
    var note: String
    var date: String
}

struct SectionWithNotes: Codable {
    var sectionName: String
    var sectionNotesArr: [Note]
}

struct ArrayOfSectionsWithNotes: Codable {
    var arrayOfNotes: [SectionWithNotes]
}
