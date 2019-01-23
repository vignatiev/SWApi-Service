//
//  RealmController.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 21.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import Foundation
import RealmSwift

var mainRealm: Realm!

final class RealmController {
  
  static var shared = RealmController()
  
  private init() { }
  
  func setup() {
    Realm.Configuration.defaultConfiguration = Realm.Configuration(schemaVersion: 0, migrationBlock: nil)
    
    do {
      mainRealm = try Realm()
    } catch let error as NSError {
      NotificationCenter.default.post(name: .RealmLoadingErrorNotifications, object: nil)
      assertionFailure("Realm loading error: \(error)")
    }
  }
  
  
}
