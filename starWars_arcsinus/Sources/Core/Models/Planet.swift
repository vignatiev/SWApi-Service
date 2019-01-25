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
  
  init(map: Map) throws {
    self.name = try map.stringIfNotEmpty("name")
    self.rotationPeriod = try map.value("rotation_period")
    self.orbitalPeriod = try map.value("orbital_period")
    self.diameter = try map.value("diameter")
    self.climate = try map.value("climate")
    self.gravity = try map.value("gravity")
    self.terrain = try map.value("terrain")
    self.surfaceWater = try map.value("surface_water")
    self.population = try map.value("population")
  }
  
}
