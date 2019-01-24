//
//  PersonDetailsTableViewCell.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 24.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import UIKit

final class PersonDetailsTableViewCell: UITableViewCell {
  
  @IBOutlet private var titleLabel: UILabel!
  @IBOutlet private var valueLabel: UILabel!
  @IBOutlet private var containerView: UIView!
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    titleLabel.text = nil
    valueLabel.text = nil
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    containerView.setShadow(withColor: .black, offset: .zero,
                            radius: 10, andOpacity: 0.23)
    containerView.layer.cornerRadius = 10
  }
  
  func configureTitle(_ title: String) {
    titleLabel.text = title
    valueLabel.isHidden = true
  }
  
  func configureTitle(_ title: String, withValue value: String) {
    titleLabel.text = title.uppercased()
    valueLabel.text = value
  }
  
}

extension PersonDetailsTableViewCell: TableViewDequeuable { }

extension PersonDetailsTableViewCell: TableViewRegisterable { }

extension PersonDetailsTableViewCell: NibLoadable { }
