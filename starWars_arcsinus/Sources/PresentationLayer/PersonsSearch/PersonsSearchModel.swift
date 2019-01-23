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
  private let searchService = SearchService.shared
  
  private let disposeBag = DisposeBag()
  
  // Input
  let searchText = PublishRelay<String>()
  
  // Output
  let persons = BehaviorRelay<[Person]>(value: [])
  let networkError = PublishRelay<ApiError>()
  
  init(personsStorage: PersonsLocalStorage) {
    self.personsStorage = personsStorage
    
    configureBindings()
  }
  
  private func configureBindings() {
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
        self.persons.accept(Array(self.personsStorage.getAllPersons()))
      })
      .disposed(by: disposeBag)
    
    // Загружаем из сети
    validText
      .debounce(0.25, scheduler: backgroundScheduler)
      .flatMapLatest { [unowned self] text -> Single<GenericResult<[Person], ApiError>> in
        // Отправляем новый запрос и отменяем предыдущий
        return self.searchForPersons(withName: text)
      }.subscribe(onNext: { [weak self] result in
        self?.processPersonsSearchResult(result)
      }).disposed(by: disposeBag)
  }
  
  private func processPersonsSearchResult(_ result: ApiSearchResult) {
    switch result {
    case .failure(let error): networkError.accept(error)
    case .success(let persons): self.persons.accept(persons)
    }
  }
  
}

extension PersonsSearchModel {
  
  private typealias ApiSearchResult = GenericResult<[Person], ApiError>
  
  private func searchForPersons(withName name: String) -> Single<ApiSearchResult> {
    // This Signal produces only .onNext events
    return Single.create(subscribe: { [unowned self] single in
      let request = self.searchService.getInfoAboutPerson(withName: name) { result in
        single(.success(result))
      }
      
      return Disposables.create {
        request.cancel()
      }
    })
  }
  
}

