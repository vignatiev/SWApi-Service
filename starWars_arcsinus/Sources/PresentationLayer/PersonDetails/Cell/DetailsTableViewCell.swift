//
//  DetailsTableViewCell.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 24.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import UIKit

final class DetailsTableViewCell: UITableViewCell {
  
  @IBOutlet private var titleLabel: UILabel!
  @IBOutlet private var valueLabel: UILabel!
  @IBOutlet private var containerView: UIView!
  @IBOutlet private var disclosureIndicatorImageView: UIImageView!
  
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
    
    titleLabel.text = nil
    valueLabel.text = nil
    disclosureIndicatorImageView.isHidden = true
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    selectionStyle = .none
    containerView.setupShadow(withColor: .black, offset: .zero,
                            radius: 10, andOpacity: 0.23)
    
    containerView.layer.cornerRadius = 10
    disclosureIndicatorImageView.isHidden = true
  }
  
  func configureTitle(_ title: String) {
    titleLabel.text = title
    valueLabel.isHidden = true
  }
  
  func configureTitle(_ title: String, withValue value: String) {
    titleLabel.text = title.uppercased()
    valueLabel.text = value
  }
  
  func configureLinkedAttribute(title: String = "", value: String = "") {
    titleLabel.text = title.uppercased()
    valueLabel.text = value
    disclosureIndicatorImageView.isHidden = false
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

extension DetailsTableViewCell: TableViewDequeuable { }

extension DetailsTableViewCell: TableViewRegisterable { }

extension DetailsTableViewCell: NibLoadable { }
