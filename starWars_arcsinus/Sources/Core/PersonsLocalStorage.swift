//
//  PersonsLocalStorage.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 21.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import RealmSwift

final class PersonsLocalStorage {
  
  static let shared = PersonsLocalStorage()
  
  private init() { }
  
  func create(person: Person) {
    let searchHistory = getAllSearchedPersons()
    guard !searchHistory.contains(person) else {
      return
    }
    let personObject = person.managedObject()
    
    mainRealm.realmWrite {
      currentUser.searchHistory.append(personObject)
    }
  }
  
  func update(person: Person) {
    guard let searchResult = currentUser.searchHistory.filter("name = %@", person.name).first else {
      return
    }
    let newValue = person.managedObject()
    
    mainRealm.realmWrite {
      searchResult.update(with: newValue)
    }
  }
  
  func getAllSearchedPersons() -> [Person] {
    let searchHistory = Set(currentUser.searchHistory.map { Person(managedObject: $0) })
    return searchHistory.sorted { $0.name > $1.name }
  }
  
}
