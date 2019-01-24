//
//  Result.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 21.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import Foundation

public enum Result<Value, Error: Swift.Error>: CustomStringConvertible, CustomDebugStringConvertible {
  case success(Value)
  case failure(Error)
  
  // MARK: Constructors
  /// Constructs a success wrapping a `value`.
  public init(value: Value) {
    self = .success(value)
  }
  
  /// Constructs a failure wrapping an `error`.
  public init(error: Error) {
    self = .failure(error)
  }
  
  /// Returns the value from `success` Results or `throw`s the error.
  public func dematerialize() throws -> Value {
    switch self {
    case let .success(value):
      return value
    case let .failure(error):
      throw error
    }
  }
  
  // MARK: CustomStringConvertible
  public var description: String {
    switch self {
    case let .success(value): return ".success(\(value))"
    case let .failure(error): return ".failure(\(error))"
    }
  }
  
  // MARK: CustomDebugStringConvertible
  public var debugDescription: String {
    return description
  }
  
}
