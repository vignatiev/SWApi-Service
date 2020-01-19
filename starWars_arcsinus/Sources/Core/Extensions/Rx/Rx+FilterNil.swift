//
//  Rx+FilterNil.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 21.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//
// https://gist.github.com/alskipp/e71f014c8f8a9aa12b8d8f8053b67d72
//

import RxSwift

public protocol OptionalType {
  associatedtype Wrapped

  var value: Wrapped? { get }
}

extension Optional: OptionalType {
  /// Cast `Optional<Wrapped>` to `Wrapped?`
  public var value: Wrapped? {
    return self
  }
}

extension ObservableType where E: OptionalType {
  /**
   Unwraps and filters out `nil` elements.
   - returns: `Observable` of source `Observable`'s elements, with `nil` elements filtered out.
   */

  public func filterNil() -> Observable<E.Wrapped> {
    return flatMap { element -> Observable<E.Wrapped> in
      guard let value = element.value else {
        return Observable<E.Wrapped>.empty()
      }
      return Observable<E.Wrapped>.just(value)
    }
  }
}
