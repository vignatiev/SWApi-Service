//
//  Planet.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 24.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import ObjectMapper

struct Planet: Mappable {
  var name: String!
  var rotationPeriod: String!
  var orbitalPeriod: String!
  var diameter: String!
  var climate: String!
  var gravity: String!
  var terrain: String!
  var surfaceWater: String!
  var population: String!
  
  init?(map: Map) {}
  
  mutating func mapping(map: Map) {
    self.name <- map["name"]
    self.rotationPeriod <- map["rotation_period"]
    self.orbitalPeriod <- map["orbital_period"]
    self.diameter <- map["diameter"]
    self.climate <- map["climate"]
    self.gravity <- map["gravity"]
    self.terrain <- map["terrain"]
    self.surfaceWater <- map["surface_water"]
    self.population <- map["population"]
  }
}
