//
//  PersonsSearchViewModel.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 21.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import RxSwift
import RxCocoa

protocol PersonsSearchModuleOutput {
  var showPersonDetails: Signal<Person> { get }
}

final class PersonsSearchViewModel: ViewModelType {
  
  private let model: PersonsSearchModel
  private let disposeBag = DisposeBag()
  
  init(model: PersonsSearchModel) {
    self.model = model
  }
  
  func transform(input: Input) -> Output {
    input.searchText
      .bind(to: model.searchText)
      .disposed(by: disposeBag)
    
    let personsOutput = model.persons.asDriver().map {
      $0.map { PersonViewModel(person: $0) }
    }
    
    let selectedPerson = input.itemWasSelected
      .withLatestFrom(model.persons) { index, persons -> Person? in
        return persons[unsafeIndex: index]
      }.filterNil()
    
    return Output(persons: personsOutput)
  }
  
  struct Input {
    let searchText: Observable<String>
    let itemWasSelected: Observable<Int> // индекс выбранного элемента
  }
  
  struct Output {
    let persons: Driver<[PersonViewModel]>
  }
  
}

extension PersonsSearchViewModel {
  
  struct PersonViewModel {
    
    let name: String
    let height: Int
    let mass: Int
    let hairColor: String
    let skinColor: String
    let eyeColor: String
    let birthYear: String
    let gender: String
    
    init(person: Person) {
      self.name = person.name
      self.height = person.height
      self.mass = person.mass
      self.hairColor = person.hairColor
      self.skinColor = person.skinColor
      self.eyeColor = person.eyeColor
      self.birthYear = person.birthYear
      self.gender = person.gender
    }
    
  }
  
}
