//
//  EmptyResultView.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 25.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import UIKit

final class EmptyResultView: UIView {
  
  @IBOutlet private var noResultsLabel: UILabel!
  @IBOutlet private var imageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    imageView.contentMode = .scaleToFill
    imageView.alpha = 0.9
    
    noResultsLabel.text = LocalizedString.emptyResultsText
    noResultsLabel.font = UIFont.systemFont(ofSize: 27, weight: .heavy)
  }

}

extension EmptyResultView: NibLoadable { }
