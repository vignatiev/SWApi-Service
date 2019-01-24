//
//  TypeToSearchView.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 24.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import UIKit

final class TypeToSearchView: UIView {

  @IBOutlet var typeToSearchLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    backgroundColor = .magenta
    layer.cornerRadius = 20
  }
  
}

extension TypeToSearchView: NibLoadable { }
