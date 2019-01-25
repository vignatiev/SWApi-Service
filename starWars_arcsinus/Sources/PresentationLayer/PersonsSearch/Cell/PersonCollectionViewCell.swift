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
  @IBOutlet private var viewWithName: UIView!
  @IBOutlet private var genderLabel: UILabel!
  @IBOutlet private var birthYearLabel: UILabel!
  @IBOutlet private var imageView: UIImageView!
  @IBOutlet private var heightLabel: UILabel!
  @IBOutlet private var massLabel: UILabel!
  @IBOutlet private var containerView: UIView!
  
  private var isTouched: Bool = false {
    didSet {
      var transform = CGAffineTransform.identity
      if isTouched {
        transform = transform.scaledBy(x: 0.96, y: 0.96)
      }
      UIView.animate(withDuration: 0.22, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8,
                     options: [.beginFromCurrentState], animations: {
                      self.transform = transform
      })
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    nameLabel.text = nil
    genderLabel.text = nil
    birthYearLabel.text = nil
    heightLabel.text = nil
    massLabel.text = nil
    
    containerView = nil
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    initialSetup()
    
    containerView.layer.shadowColor = UIColor.black.cgColor
    containerView.layer.shadowOffset = CGSize(width: 0, height: 10)
    containerView.layer.shadowRadius = 15
    containerView.layer.shadowOpacity = 0.3
  }
  
  func configureWith(viewModel: PersonsSearchViewModel.PersonViewModel) {
    nameLabel.text = "\(viewModel.name.value)"
    
    let gender = viewModel.gender
    genderLabel.text = "\(gender.title): \(gender.value)"
    
    let height = viewModel.height
    heightLabel.text = "\(height.title): \(height.value)"
    
    let mass = viewModel.mass
    massLabel.text = "\(mass.title): \(mass.value)"
    
    let birthYear = viewModel.birthYear
    birthYearLabel.text = "\(birthYear.title): \(birthYear.value)"
  }
  
  private func initialSetup() {
    let cornerRadius: CGFloat = 30
    
    imageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    imageView.layer.cornerRadius = cornerRadius

    containerView.layer.cornerRadius = cornerRadius
    containerView.layer.masksToBounds = false

    viewWithName.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    viewWithName.layer.cornerRadius = cornerRadius
    
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

extension PersonCollectionViewCell: TableViewDequeuable { }

extension PersonCollectionViewCell: TableViewRegisterable { }

extension PersonCollectionViewCell: NibLoadable { }
