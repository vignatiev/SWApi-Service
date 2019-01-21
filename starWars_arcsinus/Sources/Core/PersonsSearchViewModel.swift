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
  
  init(mode: PersonsSearchModel) {
    self.model = mode
  }
  
  func transform(input: Input) -> Output {
    return Output()
  }
  
  struct Input {
  }
  
  struct Output {
  }
  
}

extension PersonsSearchViewModel {
  
  struct PersonViewModel {
    
    init(person: Person) {
      
    }
    
  }
  
}

final class PersonsSearchModel {
  
  private let personsStorage: PersonsLocalStorage
  private let disposeBag = DisposeBag()
  
  // Input
  let searchText = PublishRelay<String>()
  
  // Output
  let persons = BehaviorRelay<[Person]>(value: [])
  
  init(personsStorage: PersonsLocalStorage) {
    self.personsStorage = personsStorage
    
    configureBindings()
  }
  
  private func configureBindings() {
    let scheduler = ConcurrentDispatchQueueScheduler(qos: .background)
    
    // Загружаем из локального хранилища
    searchText
      .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
      .filter { $0.isEmpty }
      .subscribe(onNext: { [weak self] _ in
        guard let self = self else {
          return
        }
        self.persons.accept(Array(self.personsStorage.getAllPersons()))
      })
      .disposed(by: disposeBag)
    
    // Загружаем из сети
    searchText
      .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
      .filter { $0.isNotEmpty }
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] text in
        // search persons in web
      })
      .disposed(by: disposeBag)
  }
  
  private func searchPersons(withName name: String) {
    // network request
    // persons.accept([Person])
  }
  
}
