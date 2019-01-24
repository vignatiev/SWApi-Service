//
//  UIView+PinEdges.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 24.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import UIKit

extension UIView {
  
  /// Привязывает 4 стороны к superView
  func pinEdgesTo(superView: UIView, insets: UIEdgeInsets? = nil) {
    translatesAutoresizingMaskIntoConstraints = false
    
    let constants = (insets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    
    let constraints: [NSLayoutConstraint] = [
      self.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: constants.left),
      self.topAnchor.constraint(equalTo: superView.topAnchor, constant: constants.top),
      superView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: constants.right),
      superView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: constants.bottom)
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
  
}
