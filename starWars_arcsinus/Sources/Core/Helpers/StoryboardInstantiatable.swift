//
//  StoryboardInstantiatable.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 24.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

// swiftlint:disable force_cast

import UIKit

public protocol StoryboardInstantiatable: class {
  static var storyboardId: String { get }
  static var storyboardName: String { get }
}

extension StoryboardInstantiatable where Self: UIViewController {
  public static var storyboardId: String {
    return String(describing: self)
  }
  
  public static func instantiateFromStoryboard(inBundle storyboardBundle: Bundle = Bundle.main) -> Self {
    let identifier = self.storyboardId
    let storyboard = UIStoryboard(name: storyboardName, bundle: storyboardBundle)
    
    let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as! Self
    return viewController
  }
}

enum StoryboardName: CustomStringConvertible {
  case main
  
  var description: String {
    switch self {
    case .main: return "Main"
    }
  }
}
