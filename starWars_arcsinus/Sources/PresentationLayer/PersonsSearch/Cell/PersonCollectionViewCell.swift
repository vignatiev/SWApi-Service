//
//  PersonCollectionViewCell.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 21.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import UIKit

final class PersonCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet private var nameLabel: UILabel!
  @IBOutlet private var containerView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    configureUI()
  }
  
  func configureWith(_ person: PersonsSearchViewModel.PersonViewModel) {
    nameLabel.text = person.name
  }
  
  private func configureUI() {
    containerView.layer.cornerRadius = 30
    containerView.layer.masksToBounds = true
    
    nameLabel.numberOfLines = 0
    nameLabel.textColor = .black
    nameLabel.textAlignment = .left
    nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .heavy)
  }
  
}

// MARK: - TableViewDequeuable
extension PersonCollectionViewCell: TableViewDequeuable { }

// MARK: - TableViewRegisterable
extension PersonCollectionViewCell: TableViewRegisterable { }

// MARK: - NibLoadable
extension PersonCollectionViewCell: NibLoadable { }
