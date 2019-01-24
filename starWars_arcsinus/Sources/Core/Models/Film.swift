//
//  Film.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 24.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import ObjectMapper

struct Film: ImmutableMappable {
  
  let title: String
  let episodeId: Int
  let director: String
  let producer: String
  let releaseDate: String
//  let characters: [URL]
//  let planets: [URL]
//  let starships: [URL]
//  let vehicles: [URL]
//  let species: [URL]
  
  init(map: Map) throws {
    self.title = try map.stringIfNotEmpty("title")
    self.episodeId = try map.value("episode_id")
    self.director = try map.stringIfNotEmpty("director")
    self.producer = try map.stringIfNotEmpty("producer")
    self.releaseDate = try map.stringIfNotEmpty("release_date")
  }
  
}
