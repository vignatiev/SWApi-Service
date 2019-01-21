//
//  PersonCollectionViewCell.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 21.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import UIKit

final class PersonCollectionViewCell: UICollectionViewCell {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    backgroundColor = .purple
  }
  
}

// MARK: - TableViewDequeuable
extension PersonCollectionViewCell: TableViewDequeuable { }

// MARK: - TableViewRegisterable
extension PersonCollectionViewCell: TableViewRegisterable { }

// MARK: - NibLoadable
extension PersonCollectionViewCell: NibLoadable { }
