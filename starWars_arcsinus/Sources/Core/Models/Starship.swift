//
//  Starship.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 24.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import ObjectMapper

struct Starship: ImmutableMappable {
  
  let name: String
  let model: String
  let manufacturer: String
  let costInCredits: String
  let length: String
  let maxAtmospheringSpeed: String
  let crew: String
  let passengers: String
  let cargoCapacity: String
  let consumables: String
  let hyperdriveRating: String
  let mglt: String
  let starshipClass: String
//  let pilots: [URL]
//  let films: [URL]
  
  init(map: Map) throws {
    self.name = try map.stringIfNotEmpty("name")
    self.model = try map.stringIfNotEmpty("model")
    self.manufacturer = try map.stringIfNotEmpty("manufacturer")
    self.costInCredits = try map.stringIfNotEmpty("cost_in_credits")
    self.length = try map.stringIfNotEmpty("length")
    self.maxAtmospheringSpeed = try map.stringIfNotEmpty("max_atmosphering_speed")
    self.crew = try map.stringIfNotEmpty("crew")
    self.passengers = try map.stringIfNotEmpty("passengers")
    self.cargoCapacity = try map.stringIfNotEmpty("cargo_capacity")
    self.consumables = try map.stringIfNotEmpty("consumables")
    self.hyperdriveRating = try map.stringIfNotEmpty("hyperdrive_rating")
    self.mglt = try map.stringIfNotEmpty("MGLT")
    self.starshipClass = try map.stringIfNotEmpty("starship_class")
  }
  
}
