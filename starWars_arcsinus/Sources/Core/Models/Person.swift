//
//  Person.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 19.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import ObjectMapper

struct Person: Hashable {
  
  let name: String
  let height: Int
  let mass: String
  let hairColor: String
  let skinColor: String
  let eyeColor: String
  let birthYear: String
  let gender: String
  
  init(name: String, height: Int, mass: String,
       hairColor: String, skinColor: String, eyeColor: String,
       birthYear: String, gender: String) {
    self.name = name
    self.height = height
    self.mass = mass
    self.hairColor = hairColor
    self.skinColor = skinColor
    self.eyeColor = eyeColor
    self.birthYear = birthYear
    self.gender = gender
  }
  
}

// MARK: - ImmutableMappable
extension Person: ImmutableMappable {
  
  init(map: Map) throws {
    self.name = try map.stringIfNotEmpty("name")
    self.height = try map.intFromString("height")
    self.mass = try map.stringIfNotEmpty("mass")
    self.hairColor = try map.stringIfNotEmpty("hair_color")
    self.eyeColor = try map.stringIfNotEmpty("eye_color")
    self.skinColor = try map.stringIfNotEmpty("skin_color")
    self.birthYear = try map.stringIfNotEmpty("birth_year")
    self.gender = try map.stringIfNotEmpty("gender")
  }
  
}

extension Person: Persistable {
  
  init(managedObject: PersonObject) {
    name = managedObject.name
    height = managedObject.height
    mass = managedObject.mass
    hairColor = managedObject.hairColor
    eyeColor = managedObject.eyeColor
    skinColor = managedObject.skinColor
    birthYear = managedObject.birthYear
    gender = managedObject.gender
  }
  
  func managedObject() -> PersonObject {
    let person = PersonObject()
    
    person.name = name
    person.height = height
    person.mass = mass
    person.hairColor = hairColor
    person.eyeColor = eyeColor
    person.skinColor = skinColor
    person.birthYear = birthYear
    person.gender = gender
    
    return person
  }
  
}

struct SearchResponse: ImmutableMappable {
  
  let persons: [Person]
  
  init(map: Map) throws {
    persons = try map.compactMapArrayOrEmpty("results")
  }
  
}
