//
//  DomainTransformable.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 24.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

/// Для объектов, которые могут быть преобразованы в Domain модель
protocol DomainPresentable {
  associatedtype DomainType
  
  /// в реализации метода 'throws' указывать не обязательно
  func asDomain() throws -> DomainType
}

/// Для объектов, которые могут быть получены из Domain модели
protocol DomainConvertible {
  associatedtype DomainType
  
  init(with domainInstance: DomainType) throws
}

protocol DomainTransformable: DomainPresentable, DomainConvertible {}
