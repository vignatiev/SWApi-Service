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
    
  }
  
  func update(person: Person) {
    
  }
  
  func getAllPersons() -> Set<Person> {
    let persons: Set<Person> = [Person(name: "Darth Vader", height: 202, mass: "136",
                                       hairColor: "none", skinColor: "white", eyeColor: "yellow",
                                       birthYear: "19fj", gender: "male"),
                                Person(name: "Luke Skywalker", height: 184, mass: "80",
                                       hairColor: "light", skinColor: "white", eyeColor: "green",
                                       birthYear: "1fk9", gender: "male"),
                                Person(name: "C-3PO", height: 167, mass: "75",
                                       hairColor: "n/a", skinColor: "gold", eyeColor: "yellow",
                                       birthYear: "112bb6", gender: "n/a"),
                                Person(name: "R2-D2", height: 96, mass: "32",
                                       hairColor: "n/a", skinColor: "white, blue", eyeColor: "red",
                                       birthYear: "33by", gender: "n/a"),
                                Person(name: "Leia Organa", height: 150, mass: "49",
                                       hairColor: "brwon", skinColor: "light", eyeColor: "brown",
                                       birthYear: "19bby", gender: "female"),
                                Person(name: "Owen Lars", height: 178, mass: "120",
                                       hairColor: "brown, grey", skinColor: "light", eyeColor: "blue",
                                       birthYear: "52bby", gender: "male"),
                                Person(name: "Beru Whitesun lars", height: 165, mass: "75",
                                       hairColor: "brown", skinColor: "light", eyeColor: "blue",
                                       birthYear: "47bby", gender: "female")]
    return persons
  }
  
}
