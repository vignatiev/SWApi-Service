//
//  PersonsLocalStorage.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 21.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import Foundation
import RealmSwift

final class PersonsLocalStorage {
  
  static let shared = PersonsLocalStorage()
  private let realm = try! Realm()
  
  private init() { }
  
  func create(person: Person) {
    if realm.objects(PersonObject.self).filter("name = %@", person.name).first != nil {
      return
    }
    
    let realmPerson = PersonObject(with: person)
    
    realm.realmWrite {
      realm.add(realmPerson)
    }
  }

  
  func update(person: Person) {
    guard let realmPerson = realm.objects(PersonObject.self).filter("name = %@", person.name).first else {
      return
    }
    
    realm.realmWrite {
      realmPerson.update(withDomain: person)
    }
  }
  
  func delete(person: Person) {
    guard let realmPerson = realm.objects(PersonObject.self).filter("name = %@", person.name).first else {
      return
    }
    realm.realmWrite {
      realm.delete(realmPerson)
    }
  }
  
  func getAllPersons() -> Set<Person> {
    let searchHistory = Set(realm.objects(PersonObject.self).map { $0.asDomain() })
    return searchHistory
  }
  
}

extension PersonsLocalStorage {
  
  func updateHistoryWith(persons: Set<Person>) {
    let history = getAllPersons()
    
    for person in persons {
      if history.contains(person) {
        update(person: person)
      } else {
        create(person: person)
      }
    }
    
  }
  
  func getAllPersons(sortedBy keyPath: KeyPath<Person, String>) -> [Person] {
    return getAllPersons().sorted { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
  }
  
  func getPersons(with keyPath: KeyPath<Person, String>, equalTo value: String) -> Set<Person> {
    return getAllPersons().filter { $0[keyPath: keyPath] == value }
  }
  
}

// MARK: Realm Data Structures
final class PersonObject: Object {
  
  @objc dynamic var name: String = ""
  @objc dynamic var height: Int = 0
  @objc dynamic var mass: String = ""
  @objc dynamic var hairColor: String = ""
  @objc dynamic var skinColor: String = ""
  @objc dynamic var eyeColor: String = ""
  @objc dynamic var birthYear: String = ""
  @objc dynamic var gender: String = ""
  
  func update(withDomain person: Person) {
    name = person.name
    height = person.height
    mass = person.mass
    hairColor = person.hairColor
    skinColor = person.skinColor
    eyeColor = person.eyeColor
    birthYear = person.birthYear
    gender = person.gender
  }
  
}

extension PersonObject: DomainTransformable {
  typealias DomainType = Person
  
  convenience init(with domainInstance: Person) {
    self.init()
    
    update(withDomain: domainInstance)
  }
  
  func asDomain() -> Person {
    return Person(name: name,
                  height: height,
                  mass: mass,
                  hairColor: hairColor,
                  skinColor: skinColor,
                  eyeColor: eyeColor,
                  birthYear: birthYear,
                  gender: gender)
  }
  
}
