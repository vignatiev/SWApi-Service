//
//  Rx+UIViewVisible.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 25.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIView {
  
  public var isVisible: Binder<Bool> {
    return Binder(self.base) { view, visible in
      view.isHidden = !visible
    }
  }
  
}
