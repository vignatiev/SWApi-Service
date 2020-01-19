//
//  Rx+MapVoid.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 20.01.2020.
//  Copyright © 2020 Владислав Игнатьев. All rights reserved.
//

import RxSwift

extension Observable {
  func mapVoid() -> Observable<Void> {
    return map { _ in () }
  }
}
