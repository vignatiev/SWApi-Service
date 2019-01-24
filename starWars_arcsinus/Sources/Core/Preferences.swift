//
//  Preferences.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 23.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import Foundation

final class Preferences {
  
  static let shared = Preferences()
  private let defaults = UserDefaults.standard
  
  private init() { }
  
  var firstLaunch: Bool {
    get {
      return defaults.bool(forKey: Keys.firstLaunch)
    }
    set {
      defaults.set(newValue, forKey: Keys.firstLaunch)
    }
  }
  
}

extension Preferences {
  
  private struct Keys {
    private init() { }
    
    static let firstLaunch = "isAppFirstLaunch"
  }
  
}
