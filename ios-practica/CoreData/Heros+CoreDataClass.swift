//
//  Heros+CoreDataClass.swift
//  ios-practica
//
//  Created by Eric Olsson on 2/21/23.
//

import Foundation
import CoreData

@objc(HeroCD)
public class HeroCD: NSManagedObject {

}

public extension HeroCD {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<HeroCD> {
        return NSFetchRequest<HeroCD>(entityName: "HeroCD")
    }
    
    @NSManaged var id: String?
    @NSManaged var name: String?
    @NSManaged var desc: String?
    @NSManaged var photo: String?
    @NSManaged var favorite: Bool
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
}

extension HeroCD: Identifiable {}
