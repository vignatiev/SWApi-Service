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
  let homeWorldURL: URL
  
  init(name: String, height: Int, mass: String,
       hairColor: String, skinColor: String, eyeColor: String,
       birthYear: String, gender: String, homeWorldURL: URL) {
    self.name = name
    self.height = height
    self.mass = mass
    self.hairColor = hairColor
    self.skinColor = skinColor
    self.eyeColor = eyeColor
    self.birthYear = birthYear
    self.gender = gender
    self.homeWorldURL = homeWorldURL
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
    self.homeWorldURL = try map.stringIfNotEmpty("homeworld").asURL()
  }
  
}

struct PersonsSearchResponse: ImmutableMappable {
  
  let persons: [Person]
  
  init(map: Map) throws {
    persons = try map.compactMapArrayOrEmpty("results")
  }
  
}
