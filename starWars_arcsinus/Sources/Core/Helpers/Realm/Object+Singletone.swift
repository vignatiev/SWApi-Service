//
//  Object+Singletone.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 21.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import RealmSwift
import Foundation

protocol ObjectSingletone: AnyObject {
}

extension ObjectSingletone where Self: Object {
  
  static var shared: Self {
    let object = mainRealm.objects(Self.self).first
    if let value = object {
      return value
    } else {
      let value = Self()
      
      mainRealm.realmWrite {
        mainRealm.add(value)
      }
      
      return value
    }
  }
  
}
