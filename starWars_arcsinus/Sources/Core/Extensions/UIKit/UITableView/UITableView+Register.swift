//
//  UITableView+Register.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 21.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import UIKit

/// Defines something that can be dequeued from a table view using a reuseIdentifier
/// A cell that is defined in a storyboard should implement this.
public protocol TableViewDequeuable: class {
  static var reuseIdentifier: String { get }
}

extension TableViewDequeuable {
  /// Default implementation of reuseIndentifier is to use the class name,
  /// this can be specifically implemented for difference behaviour
  public static var reuseIdentifier: String {
    return String(describing: self)
  }
}

/// Defines something that can be registered with a table view, using the reuseIdentifer
/// A cell that is laid out programmically or in a nib (that also implements NibLoadable) should implement this
public protocol TableViewRegisterable: TableViewDequeuable {}

public extension TableViewRegisterable where Self: UITableViewHeaderFooterView {
  var reuseIdentifier: String? {
    return Self.reuseIdentifier
  }
}

// MARK: - UITableView
public extension UITableView {
  
  func dequeue<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T where T: TableViewDequeuable {
    guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
      fatalError("Could not dequeue cell with identifier \(T.reuseIdentifier)")
    }
    return cell
  }
  
  func dequeue<T: UITableViewHeaderFooterView> () -> T? where T: TableViewDequeuable {
    return dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T
  }
  
  func register<T: UITableViewCell>(_ cellType: T.Type) where T: TableViewRegisterable {
    register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
  }
  
  func register<T: UITableViewCell>(_ cellType: T.Type) where T: TableViewRegisterable, T: NibLoadable {
    register(T.nib(), forCellReuseIdentifier: T.reuseIdentifier)
  }
  
  func register<T: UITableViewHeaderFooterView>(_ headerFooterType: T.Type) where T: TableViewRegisterable {
    register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
  }
  
  func register<T: UITableViewHeaderFooterView>(_ headerFooterType: T.Type)
    where T: TableViewRegisterable, T: NibLoadable {
      register(T.nib(), forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
  }
  
}

// MARK: - UICollectionView
public extension UICollectionView {
  
  func dequeueCollectionCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath)
    -> T where T: TableViewDequeuable {
      guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
        fatalError("Could not dequeue cell with identifier \(T.reuseIdentifier)")
      }
      return cell
  }
  
  func register<T: UICollectionViewCell>(_ cellType: T.Type) where T: TableViewRegisterable {
    register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
  }
  
  func register<T: UICollectionViewCell>(_ cellType: T.Type) where T: TableViewRegisterable, T: NibLoadable {
    register(T.nib(), forCellWithReuseIdentifier: T.reuseIdentifier)
  }
  
}
