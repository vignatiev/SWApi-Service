//
//  Person.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 19.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import ObjectMapper

struct Person: Hashable {
  var name: String!
  var height: String!
  var mass: String!
  var hairColor: String!
  var skinColor: String!
  var eyeColor: String!
  var birthYear: String!
  var gender: String!
  var homeWorldURL: URL!
  
  init(name: String, height: String, mass: String,
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

// MARK: - Mappable

extension Person: Mappable {
  init?(map: Map) {}
  
  mutating func mapping(map: Map) {
    self.name <- map["name"]
    self.height <- map["height"]
    self.mass <- map["mass"]
    self.hairColor <- map["hair_color"]
    self.eyeColor <- map["eye_color"]
    self.skinColor <- map["skin_color"]
    self.birthYear <- map["birth_year"]
    self.gender <- map["gender"]
    var stringUrl: String!
    stringUrl <- map["homeworld"]
    self.homeWorldURL = try! stringUrl.asURL() // swiftlint:disable:this force_try
  }
}

struct PersonsSearchResponse: Mappable {
  var persons: [Person]!
  
  init?(map: Map) {}
  
  mutating func mapping(map: Map) {
    self.persons <- map["results"]
  }
}
