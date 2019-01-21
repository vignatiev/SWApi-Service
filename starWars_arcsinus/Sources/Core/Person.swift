//
//  Person.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 19.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import ObjectMapper

struct Person {
  
  var name: String
  var height: String
  var mass: String
  var hairColor: String
  var skinColor: String
  var eyeColor: String
  var birthYear: String
  var gender: String
  
}

// MARK: - ImmutableMappable
extension Person: ImmutableMappable {
  
  init(map: Map) throws {
    self.name = try map.value("name")
    self.height = try map.value("height")
    self.mass = try map.value("mass")
    self.hairColor = try map.value("hair_color")
    self.eyeColor = try map.value("eye_color")
    self.skinColor = try map.value("skin_color")
    self.birthYear = try map.value("birth_year")
    self.gender = try map.value("gender")
  }
  
}

struct SearchResponse: ImmutableMappable {
  
  let persons: [Person]
  
  init(map: Map) throws {
    persons = try map.compactMapArrayOrEmpty("persons")
  }
  
}
