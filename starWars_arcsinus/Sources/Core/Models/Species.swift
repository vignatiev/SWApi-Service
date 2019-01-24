//
//  Species.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 24.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import ObjectMapper

struct Species: ImmutableMappable {
  
  let name: String
  let classification: String
  let designation: String
  let averageHeight: String
  let skinColors: String
  let hairColors: String
  let eyeColors: String
  let averageLifespan: String
  let homeworld: URL
  let language: String
//  let people: [URL]
//  let films: [URL]
  
  init(map: Map) throws {
    self.averageHeight = try map.stringIfNotEmpty("average_height")
    self.averageLifespan = try map.stringIfNotEmpty("average_lifespan")
    self.classification = try map.stringIfNotEmpty("classification")
    self.designation = try map.stringIfNotEmpty("designation")
    self.eyeColors = try map.stringIfNotEmpty("eye_colors")
    self.homeworld = try map.stringIfNotEmpty("homeworld").asURL()
    self.hairColors = try map.stringIfNotEmpty("hair_colors")
    self.language = try map.stringIfNotEmpty("language")
    self.name = try map.stringIfNotEmpty("name")
    self.skinColors = try map.stringIfNotEmpty("skin_colors")
  }
  
}
