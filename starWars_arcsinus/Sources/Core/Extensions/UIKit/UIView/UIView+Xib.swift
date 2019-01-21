//
//  UIView+Xib.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 19.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import UIKit

public protocol NibLoadable: AnyObject {
  /*
   Условия для работы:
   – xib файл должен называться как класс
   */
  
  static var nibName: String { get }
  static var defaultNibBundle: Bundle { get }
  
  static func nib(fromBundle nibBundle: Bundle) -> UINib
  static func loadFromNib(inBundle nibBundle: Bundle) -> Self
}

public extension NibLoadable where Self: UIView {
  static var nibName: String {
    return String(describing: self)
  }
  
  static var defaultNibBundle: Bundle {
    return Bundle.main
  }
  
  static func nib(fromBundle nibBundle: Bundle = Self.defaultNibBundle) -> UINib {
    return UINib(nibName: nibName, bundle: nibBundle)
  }
  
  static func loadFromNib(inBundle nibBundle: Bundle) -> Self {
    let view = nib(fromBundle: nibBundle)
      .instantiate(withOwner: self, options: nil).first as! Self // swiftlint:disable:this force_cast
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }
  
  static func loadFromNib() -> Self {
    let nibBundle = Bundle(for: self)
    let view = loadFromNib(inBundle: nibBundle)
    return view
  }
}
