//
//  Realm+Notifications.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 21.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import Foundation

extension Notification.Name {
  
  static let RealmLoadingErrorNotifications = Notification.Name(rawValue: "RealmLoadingErrorNotifications")
  static let RealmWritingErrorNotifications = Notification.Name(rawValue: "RealmWritingErrorNotifications")
  
}
