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
  let mass: Int
  let hairColor: String
  let skinColor: String
  let eyeColor: String
  let birthYear: String
  let gender: String
  
  init(name: String, height: Int, mass: Int,
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
    self.mass = try map.intFromString("mass")
    self.hairColor = try map.stringIfNotEmpty("hair_color")
    self.eyeColor = try map.stringIfNotEmpty("eye_color")
    self.skinColor = try map.stringIfNotEmpty("skin_color")
    self.birthYear = try map.stringIfNotEmpty("birth_year")
    self.gender = try map.stringIfNotEmpty("gender")
  }
  
}

struct SearchResponse: ImmutableMappable {
  
  let persons: [Person]
  
  init(map: Map) throws {
    persons = try map.compactMapArrayOrEmpty("persons")
  }
  
}
