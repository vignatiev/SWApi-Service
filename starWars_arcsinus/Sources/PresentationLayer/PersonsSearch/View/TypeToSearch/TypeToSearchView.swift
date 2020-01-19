//
//  TypeToSearchView.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 24.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import UIKit

final class TypeToSearchView: UIView, NibLoadable {
  @IBOutlet private var typeToSearchLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()

    typeToSearchLabel.text = LocalizedString.typeToSearchLabel
    typeToSearchLabel.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
  }
}
