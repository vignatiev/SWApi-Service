//
//  DetailsViewModelAdapter.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 20.01.2020.
//  Copyright © 2020 Владислав Игнатьев. All rights reserved.
//

import Foundation

protocol DetailsViewModelAdapter: AnyObject {
  var delegate: DetailsViewModelAdapterDelegate? { get set }
  var rowItems: [DetailsViewModelRowItem] { get }
  
  func didSelectRowAt(index: IndexPath)
}

enum DetailsViewModelRowItem {
  case header(String)
  case attribute(title: String, value: String)
  case linkedAttribute(title: String)
}

final class PersonViewModelAdapter: DetailsViewModelAdapter {
  typealias Model = Person
  
  private let searchService = SearchService.shared
  private let person: Person
  
  weak var delegate: DetailsViewModelAdapterDelegate?
  let rowItems: [DetailsViewModelRowItem]
  
  init(model: Person) {
    let rowItems: [DetailsViewModelRowItem] = [
      .attribute(title: LocalizedString.name, value: model.name.uppercased()),
      .attribute(title: LocalizedString.height, value: String(model.height)),
      .attribute(title: LocalizedString.mass, value: model.mass),
      .attribute(title: LocalizedString.hairColor, value: model.hairColor.capitalized),
      .attribute(title: LocalizedString.skinColor, value: model.skinColor.capitalized),
      .attribute(title: LocalizedString.eyeColor, value: model.eyeColor.capitalized),
      .attribute(title: LocalizedString.birthYear, value: model.birthYear.uppercased()),
      .attribute(title: LocalizedString.gender, value: model.gender.capitalized),
      .linkedAttribute(title: LocalizedString.homeworld)
    ]
    
    self.rowItems = rowItems
    self.person = model
  }
  
  func didSelectRowAt(index: IndexPath) {
    switch index.row {
    case 8:
      searchService.getPlanet(withUrl: person.homeWorldURL) { [weak self] result in
        switch result {
        case .success(let planet):
          self?.delegate?.openNewScreenWith(planet: planet)
        case .failure(let error):
          self?.delegate?.showError(error: error)
        }
      }
    default: break
    }
  }
}

final class PlanetViewModelAdapter: DetailsViewModelAdapter {
  typealias Model = Planet
  
  weak var delegate: DetailsViewModelAdapterDelegate?
  let rowItems: [DetailsViewModelRowItem]
  
  init(model: Planet) {
    let rowItems: [DetailsViewModelRowItem] = [
      .attribute(title: LocalizedString.name, value: model.name.uppercased()),
      .attribute(title: LocalizedString.rotationPeriod, value: model.rotationPeriod.uppercased()),
      .attribute(title: LocalizedString.orbitalPeriod, value: model.orbitalPeriod.uppercased()),
      .attribute(title: LocalizedString.diameter, value: model.diameter.uppercased()),
      .attribute(title: LocalizedString.climate, value: model.climate.uppercased()),
      .attribute(title: LocalizedString.gravity, value: model.gravity.uppercased()),
      .attribute(title: LocalizedString.terrain, value: model.terrain.uppercased()),
      .attribute(title: LocalizedString.surfaceWater, value: model.surfaceWater.uppercased()),
      .attribute(title: LocalizedString.population, value: model.population.uppercased())
    ]
    
    self.rowItems = rowItems
  }
  
  func didSelectRowAt(index: IndexPath) {}
}
