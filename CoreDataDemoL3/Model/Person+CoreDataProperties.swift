//
//  Person+CoreDataProperties.swift
//  CoreDataDemoL3
//
//  Created by deshollow on 29.11.2023.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> { //возвращает реквест на выборку всех сущностей Person
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var age: Int64
    @NSManaged public var gender: String?

}

extension Person : Identifiable {

}
