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
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    titleLabel = nil
    valueLabel = nil
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    initialSetup()
  }
  
  func configureWithViewModel(viewModel: String) {
    
  }
  
  private func initialSetup() {
    
  }
  
}

extension PersonDetailsTableViewCell: TableViewDequeuable { }

extension PersonDetailsTableViewCell: TableViewRegisterable { }

extension PersonDetailsTableViewCell: NibLoadable { }
