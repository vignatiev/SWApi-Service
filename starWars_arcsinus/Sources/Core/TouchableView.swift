//
//  TouchableView.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 20.01.2020.
//  Copyright © 2020 Владислав Игнатьев. All rights reserved.
//

import UIKit

protocol TouchableView: AnyObject {
  var isTouched: Bool { get set }
  
  func updateTransform(for isTouched: Bool)
}

extension TouchableView where Self: UIView {
  func updateTransform(for isTouched: Bool) {
    let newTransform = isTouched ? transform.scaledBy(x: 0.96, y: 0.96) : .identity
    UIView.animate(withDuration: 0.22,
                   delay: 0,
                   options: .beginFromCurrentState,
                   animations: { [weak self] in
                     self?.transform = newTransform
    })
  }
}
