//
//  AppDelegate.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 19.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    RealmController.shared.setup()
    if currentUser == nil {
      mainRealm.realmWrite {
        UserPreferencesEntity.shared.updateUser(currentUser: UserEntity.initStartUser())
      }
    }
    
    return true
  }
  
}
