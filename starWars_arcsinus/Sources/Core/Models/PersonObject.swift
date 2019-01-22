//
//  PersonObject.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 22.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import Foundation
import RealmSwift

final class PersonObject: Object {
  
  @objc dynamic var name: String = ""
  @objc dynamic var height: Int = 0
  @objc dynamic var mass: Int = 0
  @objc dynamic var hairColor: String = ""
  @objc dynamic var skinColor: String = ""
  @objc dynamic var eyeColor: String = ""
  @objc dynamic var birthYear: String = ""
  @objc dynamic var gender: String = ""
  
}
