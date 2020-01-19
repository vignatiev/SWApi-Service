//
//  UIView+AllNestedViews.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 21.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import UIKit

extension UIView {
  func allNestedSubviews() -> Set<UIView> {
    var allSubViews = Set(subviews)
    
    for view in subviews {
      allSubViews.formUnion(view.allNestedSubviews())
    }
    return allSubViews
  }
}
