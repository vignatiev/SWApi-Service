//
//  Planet.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 24.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import ObjectMapper

struct Planet: ImmutableMappable {
  
  let name: String
  let rotationPeriod: String
  let orbitalPeriod: String
  let diameter: String
  let climate: String
  let gravity: String
  let terrain: String
  let surfaceWater: String
  let population: String
//  let residents: [URL]
//  let films: [URL]
  
  init(map: Map) throws {
    self.name = try map.stringIfNotEmpty("name")
    self.rotationPeriod = try map.stringIfNotEmpty("rotationPeriod")
    self.orbitalPeriod = try map.stringIfNotEmpty("orbital_period")
    self.diameter = try map.stringIfNotEmpty("diameter")
    self.climate = try map.stringIfNotEmpty("climate")
    self.gravity = try map.stringIfNotEmpty("gravity")
    self.terrain = try map.stringIfNotEmpty("terrain")
    self.surfaceWater = try map.stringIfNotEmpty("surface_water")
    self.population = try map.stringIfNotEmpty("population")
  }
  
}
