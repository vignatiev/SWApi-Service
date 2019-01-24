//
//  PersonsSearchViewModel.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 21.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import RxSwift
import RxCocoa

protocol PersonsSearchModuleOutput: AnyObject {
  var showPersonDetails: Signal<Person> { get }
}

final class PersonsSearchViewModel: ViewModelType, PersonsSearchModuleOutput {
  
  private let model: PersonsSearchModel
  private let disposeBag = DisposeBag()
  
  // PersonsSearchModuleOutput Properties
  let showPersonDetails: Signal<Person>
  private let _showPersonDetails = PublishRelay<Person>()
  
  init(model: PersonsSearchModel) {
    self.model = model
    
    showPersonDetails = _showPersonDetails.asSignal()
  }
  
  // MARK: ViewModelType Impl
  func transform(input: Input) -> Output {
    input.searchText
      .bind(to: model.searchText)
      .disposed(by: disposeBag)
    
    let personsOutput = model.persons.asDriver().map {
      $0.map { PersonViewModel(person: $0) }
    }
    
    let networkErrorOutput = model.networkError.asSignal().map { $0.localizedDescription }
    
    let selectedPerson = input.itemWasSelected
      .withLatestFrom(model.persons) { index, persons -> Person? in
        return persons[unsafeIndex: index]
      }.filterNil()
    
    selectedPerson.bind(to: _showPersonDetails).disposed(by: disposeBag)
    
    return Output(persons: personsOutput,
                  showNetworkError: networkErrorOutput)
  }
  
  struct Input {
    let searchText: Observable<String>
    let itemWasSelected: Observable<Int> // индекс выбранного элемента
  }
  
  struct Output {
    let persons: Driver<[PersonViewModel]>
    let showNetworkError: Signal<String>
  }
  
}

extension PersonsSearchViewModel {
  
  struct PersonViewModel {
    
    let name: Field
    let height: Field
    let mass: Field
    let birthYear: Field
    let gender: Field
    
    init(person: Person) {
      self.name = Field(title: LocalizedString.name.capitalized,
                        value: person.name.uppercased())
      self.height = Field(title: LocalizedString.height.capitalized,
                          value: String(person.height))
      self.mass = Field(title: LocalizedString.mass.capitalized,
                        value: person.mass)
      self.birthYear = Field(title: LocalizedString.birthYear.capitalized,
                             value: person.birthYear.uppercased())
      self.gender = Field(title: LocalizedString.gender.capitalized,
                          value: person.gender.capitalized)
    }
    
    struct Field {
      let title: String
      let value: String
    }
    
  }
  
}

