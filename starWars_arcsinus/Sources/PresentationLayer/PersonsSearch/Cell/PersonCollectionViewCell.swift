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
  
  private var isTouched: Bool = false {
    didSet {
      var transform = CGAffineTransform.identity
      if isTouched {
        transform = transform.scaledBy(x: 0.9, y: 0.9)
      }
      UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [.beginFromCurrentState], animations: {
        self.transform = transform
      })
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    configureUI()
  }
  
  func configureWith(viewModel: PersonsSearchViewModel.PersonViewModel) {
    nameLabel.text = viewModel.name
  }
  
  private func configureUI() {
    containerView.layer.cornerRadius = 30
    containerView.layer.masksToBounds = true
    
    nameLabel.numberOfLines = 0
    nameLabel.textColor = .black
    nameLabel.textAlignment = .left
    nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .heavy)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    isTouched = true
  }
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    isTouched = false
  }
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesCancelled(touches, with: event)
    isTouched = false
  }
  
}

// MARK: - TableViewDequeuable
extension PersonCollectionViewCell: TableViewDequeuable { }

// MARK: - TableViewRegisterable
extension PersonCollectionViewCell: TableViewRegisterable { }

// MARK: - NibLoadable
extension PersonCollectionViewCell: NibLoadable { }
