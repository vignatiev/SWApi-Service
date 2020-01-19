//
//  Realm+WriteFunctions.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 21.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import Foundation
import RealmSwift

extension Realm {
  public func realmWrite(_ block: () -> Void) {
    if isInWriteTransaction {
      block()
    } else {
      do {
        try write(block)
      } catch {
        assertionFailure("Realm write error: \(error)")
      }
    }
  }
}
