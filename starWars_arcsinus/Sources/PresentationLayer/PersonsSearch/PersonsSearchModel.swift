//
//  PersonsSearchModel.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 21.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import RxSwift
import RxCocoa

final class PersonsSearchModel {
  
  private let personsStorage: PersonsLocalStorage
  private let searchService: SearchService
  
  private let disposeBag = DisposeBag()
  
  // Input
  let searchText = PublishRelay<String>()
  let didSelectPerson = PublishRelay<Person>()
  
  // Output
  let persons = BehaviorRelay(value: PersonsData(persons: [], areLocal: true))
  let networkError = PublishRelay<ApiError>()
  
  init(personsStorage: PersonsLocalStorage, searchService: SearchService = SearchService.shared) {
    self.personsStorage = personsStorage
    self.searchService = searchService
    
    configureBindings()
  }
  
  private func configureBindings() {
    didSelectPerson.subscribe(onNext: { [weak personsStorage] person in
      try? personsStorage?.create(entity: person)
    }).disposed(by: disposeBag)
    
    let backgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
    
    let invalidText = searchText
      .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
      .filter { $0.isEmpty }
    
    let validText = searchText
      .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
      .filter { $0.isNotEmpty }
      .distinctUntilChanged()
    
    // Загружаем из локального хранилища
    invalidText
      .subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }
        
        let persons = self.personsStorage.getAllEntities()
        self.persons.accept(PersonsData(persons: persons, areLocal: true))
      })
      .disposed(by: disposeBag)
    
    // Загружаем из сети
    validText
      .debounce(0.45, scheduler: backgroundScheduler)
      .flatMapLatest { [unowned self] text -> Single<Result<[Person], ApiError>> in
        // Отправляем новый запрос и отменяем предыдущий
        return self.searchForPersons(withName: text)
      }.subscribe(onNext: { [weak self] result in
        self?.processPersonsSearchResult(result)
      }).disposed(by: disposeBag)
  }
  
  private func processPersonsSearchResult(_ result: ApiSearchResult) {
    switch result {
    case .failure(let error): networkError.accept(error)
    case .success(let persons): self.persons.accept(PersonsData(persons: Set(persons), areLocal: false))
    }
  }
  
  struct PersonsData {
    let persons: Set<Person>
    let areLocal: Bool
  }
  
}

extension PersonsSearchModel {
  
  private typealias ApiSearchResult = Result<[Person], ApiError>
  
  private func searchForPersons(withName name: String) -> Single<ApiSearchResult> {
    // This Signal produces only .onNext events
    return Single.create(subscribe: { [unowned self] single in
      let request = self.searchService.getPerson(withName: name) { result in
        single(.success(result))
      }
      
      return Disposables.create {
        request.cancel()
      }
    })
  }
  
}
