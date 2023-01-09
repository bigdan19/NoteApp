//
//  Note.swift
//  NoteApp
//
//  Created by Daniel on 09/01/2023.
//

import CoreData

@objc(Note)
class Note: NSManagedObject {
    @NSManaged var id: NSNumber!
    @NSManaged var desc: NSString!
    @NSManaged var date: NSString!
}
