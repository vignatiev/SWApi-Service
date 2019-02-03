//
//  PersonsLocalStorage.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 21.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import Foundation
import RealmSwift

final class PersonsLocalStorage: LocalStorage<Person, PersonObject> {
  static let shared = PersonsLocalStorage()
  
  override var uniqueKeyName: String { return "name" }
  override var uniqueKeyPath: PartialKeyPath<Person> { return \Person.name as PartialKeyPath<Person> }
}

// MARK: Realm Data Structures
final class PersonObject: Object {
  
  @objc dynamic var name: String = ""
  @objc dynamic var height: String = ""
  @objc dynamic var mass: String = ""
  @objc dynamic var hairColor: String = ""
  @objc dynamic var skinColor: String = ""
  @objc dynamic var eyeColor: String = ""
  @objc dynamic var birthYear: String = ""
  @objc dynamic var gender: String = ""
  @objc dynamic var homeworldURL: String = ""
  
  func updateData(withDomain person: Person) {
    name = person.name
    height = person.height
    mass = person.mass
    hairColor = person.hairColor
    skinColor = person.skinColor
    eyeColor = person.eyeColor
    birthYear = person.birthYear
    gender = person.gender
    homeworldURL = person.homeWorldURL.relativeString
  }
  
}

extension PersonObject: RealmDomainTransformable {
  
  typealias DomainType = Person
  
  func asDomain() throws -> Person {
    let homeWorldURL = try homeworldURL.asURL()
    
    return Person(name: name,
                  height: height,
                  mass: mass,
                  hairColor: hairColor,
                  skinColor: skinColor,
                  eyeColor: eyeColor,
                  birthYear: birthYear,
                  gender: gender,
                  homeWorldURL: homeWorldURL)
  }
  
}
