//
//  Persistable.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 22.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import RealmSwift

protocol Persistable {
  associatedtype ManagedObject: RealmSwift.Object
  
  init(managedObject: ManagedObject)
  
  func managedObject() -> ManagedObject
  
}
