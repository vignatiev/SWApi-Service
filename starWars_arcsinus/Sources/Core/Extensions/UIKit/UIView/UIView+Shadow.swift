//
//  UIView+Shadow.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 24.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import UIKit

extension UIView {
  func setupShadow(withColor color: UIColor, offset: CGSize, radius: CGFloat, andOpacity opacity: Float) {
    self.layer.shadowRadius = radius
    self.layer.shadowOffset = offset
    self.layer.shadowOpacity = opacity
    self.layer.shadowColor = color.cgColor
  }
}
