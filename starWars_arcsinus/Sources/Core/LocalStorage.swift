//
//  LocalStorage.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 03.02.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import RealmSwift

protocol RealmDomainTransformable: DomainTransformable, AnyObject {
  func updateData(withDomain person: DomainType)
}

extension RealmDomainTransformable where Self: Object {
  init(with domainInstance: DomainType) {
    self.init()
    
    updateData(withDomain: domainInstance)
  }
}

class LocalStorage<Model, RealmObject> where Model: Hashable,
RealmObject: Object & RealmDomainTransformable, RealmObject.DomainType == Model {
  
  private let realm = try! Realm() // swiftlint:disable:this force_try
  
  var uniqueKeyName: String {
    return ""
  }
  
  var uniqueKeyPath: PartialKeyPath<Model> {
    return \.hashValue
  }
  
  init() {}
  
  func create(entity: Model) throws {
    if firstRealmObject(of: entity) != nil {
      throw StorageError.tryingCreateDuplicate
    }
    
    let realmObject = try RealmObject(with: entity)
    
    realm.realmWrite {
      realm.add(realmObject)
    }
  }
  
  func update(entity: Model) throws {
    guard let realmObject = firstRealmObject(of: entity) else {
      throw StorageError.missingObject
    }
    
    realm.realmWrite {
      realmObject.updateData(withDomain: entity)
    }
  }
  
  func delete(entity: Model) throws {
    guard let realmObject = firstRealmObject(of: entity) else {
      throw StorageError.missingObject
    }
    
    realm.realmWrite {
      realm.delete(realmObject)
    }
  }
  
  func getAllEntities() -> Set<Model> {
    return Set(realm.objects(RealmObject.self).compactMap { try? $0.asDomain() })
  }
  
  func getEntities<V>(with keyPath: KeyPath<Model, V>, equalTo value: V) -> Set<Model> where V: Equatable {
    return getAllEntities().filter { $0[keyPath: keyPath] == value }
  }
  
  /// Возвращает единственный объект соответствующий критерям. Если таких объектов больше, то будет throw
  func theOnlyEntity<V>(with keyPath: KeyPath<Model, V>, equalTo value: V) throws -> Model where V: Equatable {
    let entities = getAllEntities().filter { $0[keyPath: keyPath] == value }
    
    guard entities.count <= 1 else {
      throw StorageError.entityIsNotUnique
    }
    
    guard let entity = entities.first else {
      throw StorageError.entityNotFound
    }
    
    return entity
  }
  
  private func firstRealmObject(of entity: Model) -> RealmObject? {
    let predicate = uniqueKeyName + " = %@"
    
    return realm.objects(RealmObject.self).filter(predicate, entity[keyPath: uniqueKeyPath]).first
  }
}

extension LocalStorage {
  
  func getAllEntities<V>(sortedBy keyPath: KeyPath<Model, V>,
                         _ sorting: Sorting) -> [Model] where V: Comparable {
    switch sorting {
    case .ascending: return getAllEntities().sorted { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
    case .descending: return getAllEntities().sorted { $0[keyPath: keyPath] > $1[keyPath: keyPath] }
    }
  }
  
  enum Sorting {
    case ascending
    case descending
  }
  
  enum StorageError: Error {
    case tryingCreateDuplicate
    case missingObject
    case entityIsNotUnique
    case entityNotFound
  }
  
}
