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
  
  // MARK: PersonsSearchModuleOutput Properties
  let showPersonDetails: Signal<Person>
  private let _showPersonDetails = PublishRelay<Person>()
  
  init(model: PersonsSearchModel) {
    self.model = model
    
    showPersonDetails = _showPersonDetails.asSignal()
  }
  
  // MARK: ViewModelType Implementation
  func transform(input: Input) -> Output {
    input.searchText
      .bind(to: model.searchText)
      .disposed(by: disposeBag)
    
    // View Output
    let sortedPersons = model.persons.asDriver().map {
      $0.persons.sorted { $0.name < $1.name }
    }
    
    let personsOutput = sortedPersons.map {
      $0.map { PersonViewModel(person: $0) }
    }
    
    let networkErrorOutput = model.networkError.asSignal().map { $0.errorDescription }
    
    let pageControlVisible = sortedPersons.map { $0.isNotEmpty }
    let collectionViewVisible = sortedPersons.map { $0.isNotEmpty }
    
    let typeToSearchViewVisible = model.persons.asDriver().map { $0.areLocal && $0.persons.isEmpty }
    let isEmptyResultViewVisible = model.persons.asDriver().map { !$0.areLocal && $0.persons.isEmpty }
    
    let isDataSourceLabelVisible = model.persons.asDriver().map { $0.persons.isNotEmpty }
    let dataSource = model.persons.asDriver()
      .map {
        return $0.areLocal ? LocalizedString.personSearchSourceLocal : LocalizedString.personSearchSourceResponse
      }.map { $0.uppercased() }
    
    let contentAbsenceViewVisibile = Observable
      .combineLatest(typeToSearchViewVisible.asObservable(), isEmptyResultViewVisible.asObservable())
      .map { $0 || $1 }
    
    let hideKeyboard = hideKeyboardAfterSearch(searchText: input.searchText,
                                               contentAbsenceViewVisibile: contentAbsenceViewVisibile)
    
    // Module Output
    let selectedPerson = input.itemWasSelected
      .withLatestFrom(sortedPersons) { index, persons -> Person? in
        return persons[unsafeIndex: index]
      }.filterNil()
    
    selectedPerson.bind(to: _showPersonDetails).disposed(by: disposeBag)
    selectedPerson.bind(to: model.didSelectPerson).disposed(by: disposeBag)
    
    return Output(persons: personsOutput,
                  showNetworkError: networkErrorOutput,
                  hideKeyboardAfterSearch: hideKeyboard,
                  typeToSearchViewVisible: typeToSearchViewVisible,
                  pageControlVisivble: pageControlVisible,
                  collectionViewVisivble: collectionViewVisible,
                  isEmptyResultViewVisible: isEmptyResultViewVisible,
                  isDataSourceLabelVisible: isDataSourceLabelVisible,
                  dataSource: dataSource)
  }
  
  private func hideKeyboardAfterSearch(searchText: Observable<String>,
                                       contentAbsenceViewVisibile: Observable<Bool>) -> Signal<Void> {
    // Если результаты поиска или история просмотренных персонажей пусты, то клавиатура не прячется
    let keyboardHidingDelay: Double = 1
    let textInputTimeStamps = searchText.map { _ in Date().timeIntervalSince1970 }
    let delayedPersonsUpdate = model.persons
      .map { _ in Void() }
      .delay(keyboardHidingDelay, scheduler: MainScheduler.instance)
    
    let hideKeyboardTrigger = delayedPersonsUpdate
      .withLatestFrom(textInputTimeStamps)
      .filter { lastInputTimeStamp in
        let currentTime = Date().timeIntervalSince1970
        
        return (currentTime - lastInputTimeStamp) > keyboardHidingDelay
    }
    
    let hideKeyboard = hideKeyboardTrigger
      .withLatestFrom(contentAbsenceViewVisibile)
      .filter { $0 == false }
      .map { _ in Void() }
      .asSignal(onErrorJustReturn: Void())
    
    return hideKeyboard
  }
  
  struct Input {
    let searchText: Observable<String>
    let itemWasSelected: Observable<Int> // индекс выбранного элемента
  }
  
  struct Output {
    let persons: Driver<[PersonViewModel]>
    let showNetworkError: Signal<String>
    let hideKeyboardAfterSearch: Signal<Void>
    
    let typeToSearchViewVisible: Driver<Bool>
    let pageControlVisivble: Driver<Bool>
    let collectionViewVisivble: Driver<Bool>
    let isEmptyResultViewVisible: Driver<Bool>
    let isDataSourceLabelVisible: Driver<Bool>
    
    let dataSource: Driver<String>
  }
  
}

extension PersonsSearchViewModel {
  
  // MARK: - PersonViewModel
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
