//
//  UserEntity.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 21.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import Foundation
import RealmSwift

final class UserEntity: Object {
  
  @objc dynamic var firstLaunch = false
  let searchHistory = List<PersonObject>()
  
  static func initStartUser() -> UserEntity {
    return UserEntity()
  }
  
}

final class UserPreferencesEntity: Object, ObjectSingletone {
  
  @objc private(set) dynamic var currentUser: UserEntity!
  
  func updateUser(currentUser: UserEntity) {
    self.currentUser = currentUser
  }
  
}

var currentUser: UserEntity! = UserPreferencesEntity.shared.currentUser
