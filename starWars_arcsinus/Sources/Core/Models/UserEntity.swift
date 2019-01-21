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
//  let searchHistory = List<Person>()
  
//  override static func primaryKey() -> String? {
//    return "id"
//  }
  
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

var CurrentUser: UserEntity! = UserPreferencesEntity.value.currentUser